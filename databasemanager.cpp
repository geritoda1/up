#include "databasemanager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QCoreApplication>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    initDatabase();

    m_groupsModel = new SqlQueryModel(this);
    m_teachersModel = new SqlQueryModel(this);
    m_studentsModel = new SqlQueryModel(this);
    m_subjectsModel = new SqlQueryModel(this);
    m_journalModel = new SqlQueryModel(this);
    m_studentJournalModel = new SqlQueryModel(this);

    refreshAll();
}

DatabaseManager::~DatabaseManager() {
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void DatabaseManager::initDatabase() {
    QString dbPath = QCoreApplication::applicationDirPath() + "/university.db";
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qDebug() << "Ошибка БД:" << m_db.lastError().text();
        return;
    }

    QSqlQuery query;
    // 1. Таблица групп
    query.exec("CREATE TABLE IF NOT EXISTS groups ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "name TEXT NOT NULL UNIQUE)");

    // 2. Таблица пользователей (декан, преподаватели, студенты)
    query.exec("CREATE TABLE IF NOT EXISTS users ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "login TEXT NOT NULL UNIQUE, "
               "password TEXT NOT NULL, "
               "role TEXT NOT NULL, "
               "full_name TEXT NOT NULL, "
               "group_id INTEGER, "
               "FOREIGN KEY(group_id) REFERENCES groups(id))");

    // 3. Таблица дисциплин
    query.exec("CREATE TABLE IF NOT EXISTS subjects ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "title TEXT NOT NULL, "
               "teacher_id INTEGER, "
               "FOREIGN KEY(teacher_id) REFERENCES users(id))");

    // 4. Таблица журнала посещаемости и успеваемости
    query.exec("CREATE TABLE IF NOT EXISTS journal ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "student_id INTEGER NOT NULL, "
               "subject_id INTEGER NOT NULL, "
               "lesson_date TEXT NOT NULL, "
               "attendance TEXT NOT NULL, "
               "grade TEXT, "
               "FOREIGN KEY(student_id) REFERENCES users(id), "
               "FOREIGN KEY(subject_id) REFERENCES subjects(id))");

    // Гарантируем наличие аккаунта декана для первого запуска
    query.exec("SELECT COUNT(*) FROM users WHERE role = 'dean'");
    if (query.next() && query.value(0).toInt() == 0) {
        query.exec("INSERT INTO users (login, password, role, full_name, group_id) "
                   "VALUES ('dean', '123', 'dean', 'Деканат (Администратор)', NULL)");
    }
}

void DatabaseManager::refreshAll() {
    m_groupsModel->setQuery("SELECT name, id FROM groups ORDER BY name ASC");

    m_teachersModel->setQuery(
        "SELECT full_name, id, login FROM users WHERE role = 'teacher' ORDER BY full_name ASC"
        );

    m_studentsModel->setQuery(
        "SELECT u.full_name, u.id, u.login, COALESCE(g.name, 'Без группы') AS group_name, u.group_id "
        "FROM users u LEFT JOIN groups g ON u.group_id = g.id "
        "WHERE u.role = 'student' ORDER BY u.full_name ASC"
        );

    if (m_currentTeacherId > 0) {
        loadTeacherData(m_currentTeacherId);
    } else {
        m_subjectsModel->setQuery(
            "SELECT s.title, s.id, COALESCE(u.full_name, 'Не назначен') AS teacher_name, s.teacher_id "
            "FROM subjects s LEFT JOIN users u ON s.teacher_id = u.id ORDER BY s.title ASC"
            );
        m_journalModel->setQuery(
            "SELECT j.id, j.student_id, j.subject_id, u.full_name AS student_name, "
            "COALESCE(g.name, '—') AS group_name, s.title AS subject_title, "
            "j.lesson_date, j.attendance, COALESCE(j.grade, '') AS grade "
            "FROM journal j "
            "JOIN users u ON j.student_id = u.id "
            "LEFT JOIN groups g ON u.group_id = g.id "
            "JOIN subjects s ON j.subject_id = s.id "
            "ORDER BY j.id DESC"
            );
    }

    if (m_currentStudentId > 0) {
        loadStudentData(m_currentStudentId);
    }

    emit dataChanged();
}

bool DatabaseManager::addGroup(const QString &name) {
    if (name.trimmed().isEmpty()) return false;
    QSqlQuery q;
    q.prepare("INSERT INTO groups (name) VALUES (:name)");
    q.bindValue(":name", name.trimmed());
    bool ok = q.exec();
    refreshAll();
    return ok;
}

void DatabaseManager::deleteGroup(int groupId) {
    QSqlQuery q;
    q.prepare("UPDATE users SET group_id = NULL WHERE group_id = :gid");
    q.bindValue(":gid", groupId);
    q.exec();

    q.prepare("DELETE FROM groups WHERE id = :id");
    q.bindValue(":id", groupId);
    q.exec();
    refreshAll();
}

bool DatabaseManager::addUser(const QString &login, const QString &password, const QString &role, const QString &fullName, int groupId) {
    if (login.trimmed().isEmpty() || password.trimmed().isEmpty() || fullName.trimmed().isEmpty())
        return false;

    QSqlQuery q;
    q.prepare("INSERT INTO users (login, password, role, full_name, group_id) "
              "VALUES (:login, :password, :role, :full_name, :group_id)");
    q.bindValue(":login", login.trimmed());
    q.bindValue(":password", password.trimmed());
    q.bindValue(":role", role);
    q.bindValue(":full_name", fullName.trimmed());
    if (role == "student" && groupId > 0)
        q.bindValue(":group_id", groupId);
    else
        q.bindValue(":group_id", QVariant());

    bool ok = q.exec();
    refreshAll();
    return ok;
}

void DatabaseManager::deleteUser(int userId) {
    QSqlQuery q;
    q.prepare("DELETE FROM journal WHERE student_id = :id");
    q.bindValue(":id", userId);
    q.exec();

    q.prepare("DELETE FROM users WHERE id = :id");
    q.bindValue(":id", userId);
    q.exec();
    refreshAll();
}

bool DatabaseManager::addSubject(const QString &title, int teacherId) {
    if (title.trimmed().isEmpty()) return false;
    QSqlQuery q;
    q.prepare("INSERT INTO subjects (title, teacher_id) VALUES (:title, :tid)");
    q.bindValue(":title", title.trimmed());
    if (teacherId > 0)
        q.bindValue(":tid", teacherId);
    else
        q.bindValue(":tid", QVariant());

    bool ok = q.exec();
    refreshAll();
    return ok;
}

void DatabaseManager::deleteSubject(int subjectId) {
    QSqlQuery q;
    q.prepare("DELETE FROM journal WHERE subject_id = :id");
    q.bindValue(":id", subjectId);
    q.exec();

    q.prepare("DELETE FROM subjects WHERE id = :id");
    q.bindValue(":id", subjectId);
    q.exec();
    refreshAll();
}

void DatabaseManager::loadTeacherData(int teacherId) {
    m_currentTeacherId = teacherId;
    m_currentStudentId = -1;

    // Если у преподавателя есть свои предметы — показываем их, иначе все предметы
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT COUNT(*) FROM subjects WHERE teacher_id = :tid");
    checkQuery.bindValue(":tid", teacherId);
    checkQuery.exec();
    bool hasOwnSubjects = (checkQuery.next() && checkQuery.value(0).toInt() > 0);

    if (hasOwnSubjects) {
        m_subjectsModel->setQuery(QString(
                                      "SELECT s.title, s.id, COALESCE(u.full_name, '') AS teacher_name, s.teacher_id "
                                      "FROM subjects s LEFT JOIN users u ON s.teacher_id = u.id "
                                      "WHERE s.teacher_id = %1 ORDER BY s.title ASC"
                                      ).arg(teacherId));
    } else {
        m_subjectsModel->setQuery(
            "SELECT s.title, s.id, COALESCE(u.full_name, 'Не назначен') AS teacher_name, s.teacher_id "
            "FROM subjects s LEFT JOIN users u ON s.teacher_id = u.id ORDER BY s.title ASC"
            );
    }

    m_journalModel->setQuery(
        "SELECT j.id, j.student_id, j.subject_id, u.full_name AS student_name, "
        "COALESCE(g.name, '—') AS group_name, s.title AS subject_title, "
        "j.lesson_date, j.attendance, COALESCE(j.grade, '') AS grade "
        "FROM journal j "
        "JOIN users u ON j.student_id = u.id "
        "LEFT JOIN groups g ON u.group_id = g.id "
        "JOIN subjects s ON j.subject_id = s.id "
        "ORDER BY j.id DESC"
        );
}

void DatabaseManager::addJournalRecord(int studentId, int subjectId, const QString &date, const QString &attendance, const QString &grade) {
    if (studentId <= 0 || subjectId <= 0 || date.trimmed().isEmpty()) return;

    QSqlQuery q;
    q.prepare("INSERT INTO journal (student_id, subject_id, lesson_date, attendance, grade) "
              "VALUES (:sid, :subid, :date, :att, :grade)");
    q.bindValue(":sid", studentId);
    q.bindValue(":subid", subjectId);
    q.bindValue(":date", date.trimmed());
    q.bindValue(":att", attendance);
    q.bindValue(":grade", grade.trimmed());
    q.exec();

    loadTeacherData(m_currentTeacherId);
}

void DatabaseManager::updateJournalRecord(int recordId, const QString &date, const QString &attendance, const QString &grade) {
    if (recordId <= 0) return;

    QSqlQuery q;
    q.prepare("UPDATE journal SET lesson_date = :date, attendance = :att, grade = :grade WHERE id = :id");
    q.bindValue(":date", date.trimmed());
    q.bindValue(":att", attendance);
    q.bindValue(":grade", grade.trimmed());
    q.bindValue(":id", recordId);
    q.exec();

    loadTeacherData(m_currentTeacherId);
}

void DatabaseManager::deleteJournalRecord(int recordId) {
    QSqlQuery q;
    q.prepare("DELETE FROM journal WHERE id = :id");
    q.bindValue(":id", recordId);
    q.exec();

    loadTeacherData(m_currentTeacherId);
}

void DatabaseManager::loadStudentData(int studentId) {
    m_currentStudentId = studentId;
    m_currentTeacherId = -1;

    m_studentJournalModel->setQuery(QString(
                                        "SELECT j.id, s.title AS subject_title, COALESCE(u.full_name, '—') AS teacher_name, "
                                        "j.lesson_date, j.attendance, COALESCE(j.grade, '—') AS grade "
                                        "FROM journal j "
                                        "JOIN subjects s ON j.subject_id = s.id "
                                        "LEFT JOIN users u ON s.teacher_id = u.id "
                                        "WHERE j.student_id = %1 "
                                        "ORDER BY j.id DESC"
                                        ).arg(studentId));

    // Считаем средний балл
    QSqlQuery qAvg;
    qAvg.prepare("SELECT AVG(CAST(grade AS REAL)) FROM journal WHERE student_id = :sid AND grade IN ('2','3','4','5')");
    qAvg.bindValue(":sid", studentId);
    if (qAvg.exec() && qAvg.next() && !qAvg.value(0).isNull()) {
        m_studentAvgGrade = QString::number(qAvg.value(0).toDouble(), 'f', 2);
    } else {
        m_studentAvgGrade = "Нет оценок";
    }

    // Считаем процент посещаемости
    QSqlQuery qAtt;
    qAtt.prepare("SELECT COUNT(*), SUM(CASE WHEN attendance = 'Присутствовал' THEN 1 ELSE 0 END) "
                 "FROM journal WHERE student_id = :sid");
    qAtt.bindValue(":sid", studentId);
    if (qAtt.exec() && qAtt.next() && qAtt.value(0).toInt() > 0) {
        int total = qAtt.value(0).toInt();
        int present = qAtt.value(1).toInt();
        int percent = (present * 100) / total;
        m_studentAttendancePercent = QString::number(percent) + "% (" + QString::number(present) + " из " + QString::number(total) + ")";
    } else {
        m_studentAttendancePercent = "100% (0 занятий)";
    }

    emit statsChanged();
}

int DatabaseManager::getGroupIdByIndex(int row) const {
    if (row < 0 || row >= m_groupsModel->rowCount()) return -1;
    return m_groupsModel->record(row).value("id").toInt();
}

int DatabaseManager::getTeacherIdByIndex(int row) const {
    if (row < 0 || row >= m_teachersModel->rowCount()) return -1;
    return m_teachersModel->record(row).value("id").toInt();
}

int DatabaseManager::getStudentIdByIndex(int row) const {
    if (row < 0 || row >= m_studentsModel->rowCount()) return -1;
    return m_studentsModel->record(row).value("id").toInt();
}

int DatabaseManager::getSubjectIdByIndex(int row) const {
    if (row < 0 || row >= m_subjectsModel->rowCount()) return -1;
    return m_subjectsModel->record(row).value("id").toInt();
}