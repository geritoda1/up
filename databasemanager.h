#pragma once
#include <QObject>
#include <QSqlDatabase>
#include <QSqlQueryModel>
#include <QSqlRecord>

class SqlQueryModel : public QSqlQueryModel {
    Q_OBJECT
public:
    explicit SqlQueryModel(QObject *parent = nullptr) : QSqlQueryModel(parent) {}

    QVariant data(const QModelIndex &index, int role) const override {
        if (role < Qt::UserRole)
            return QSqlQueryModel::data(index, role);

        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }

    QHash<int, QByteArray> roleNames() const override {
        QHash<int, QByteArray> roles;
        for (int i = 0; i < this->record().count(); ++i) {
            roles.insert(Qt::UserRole + i + 1, this->record().fieldName(i).toUtf8());
        }
        return roles;
    }
};

class DatabaseManager : public QObject {
    Q_OBJECT
    // Модели для привязки данных (Data Binding)
    Q_PROPERTY(SqlQueryModel* groupsModel READ groupsModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* teachersModel READ teachersModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* studentsModel READ studentsModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* subjectsModel READ subjectsModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* journalModel READ journalModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* studentJournalModel READ studentJournalModel CONSTANT)

    // Статистика студента
    Q_PROPERTY(QString studentAvgGrade READ studentAvgGrade NOTIFY statsChanged)
    Q_PROPERTY(QString studentAttendancePercent READ studentAttendancePercent NOTIFY statsChanged)

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    SqlQueryModel* groupsModel() const { return m_groupsModel; }
    SqlQueryModel* teachersModel() const { return m_teachersModel; }
    SqlQueryModel* studentsModel() const { return m_studentsModel; }
    SqlQueryModel* subjectsModel() const { return m_subjectsModel; }
    SqlQueryModel* journalModel() const { return m_journalModel; }
    SqlQueryModel* studentJournalModel() const { return m_studentJournalModel; }

    QString studentAvgGrade() const { return m_studentAvgGrade; }
    QString studentAttendancePercent() const { return m_studentAttendancePercent; }

    // --- Методы Декана ---
    Q_INVOKABLE bool addGroup(const QString &name);
    Q_INVOKABLE void deleteGroup(int groupId);
    Q_INVOKABLE bool addUser(const QString &login, const QString &password, const QString &role, const QString &fullName, int groupId);
    Q_INVOKABLE void deleteUser(int userId);
    Q_INVOKABLE bool addSubject(const QString &title, int teacherId);
    Q_INVOKABLE void deleteSubject(int subjectId);

    // --- Методы Преподавателя (Манипулирование данными журнала) ---
    Q_INVOKABLE void loadTeacherData(int teacherId);
    Q_INVOKABLE void addJournalRecord(int studentId, int subjectId, const QString &date, const QString &attendance, const QString &grade);
    Q_INVOKABLE void updateJournalRecord(int recordId, const QString &date, const QString &attendance, const QString &grade);
    Q_INVOKABLE void deleteJournalRecord(int recordId);

    // --- Методы Студента ---
    Q_INVOKABLE void loadStudentData(int studentId);

    // --- Вспомогательные геттеры ID для выпадающих списков (ComboBox) ---
    Q_INVOKABLE int getGroupIdByIndex(int row) const;
    Q_INVOKABLE int getTeacherIdByIndex(int row) const;
    Q_INVOKABLE int getStudentIdByIndex(int row) const;
    Q_INVOKABLE int getSubjectIdByIndex(int row) const;

    Q_INVOKABLE void refreshAll();

signals:
    void dataChanged();
    void statsChanged();

private:
    QSqlDatabase m_db;
    SqlQueryModel *m_groupsModel;
    SqlQueryModel *m_teachersModel;
    SqlQueryModel *m_studentsModel;
    SqlQueryModel *m_subjectsModel;
    SqlQueryModel *m_journalModel;
    SqlQueryModel *m_studentJournalModel;

    int m_currentTeacherId = -1;
    int m_currentStudentId = -1;
    QString m_studentAvgGrade = "0.00";
    QString m_studentAttendancePercent = "0%";

    void initDatabase();
};