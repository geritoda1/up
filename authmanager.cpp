#include "authmanager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>

AuthManager::AuthManager(QObject *parent) : QObject(parent) {}

bool AuthManager::login(const QString &username, const QString &password) {
    QSqlQuery query;
    query.prepare(
        "SELECT u.id, u.role, u.full_name, COALESCE(g.name, 'Без группы') "
        "FROM users u LEFT JOIN groups g ON u.group_id = g.id "
        "WHERE u.login = :login AND u.password = :password"
        );
    query.bindValue(":login", username.trimmed());
    query.bindValue(":password", password.trimmed());

    if (query.exec() && query.next()) {
        m_userId = query.value(0).toInt();
        m_userRole = query.value(1).toString();
        m_fullName = query.value(2).toString();
        m_groupName = query.value(3).toString();
        emit authChanged();
        return true;
    }
    return false;
}

QString AuthManager::registerAccount(const QString &username, const QString &password,
                                     const QString &role, const QString &fullName, int groupId) {
    if (username.trimmed().isEmpty() || password.trimmed().isEmpty() || fullName.trimmed().isEmpty()) {
        return "Заполните все обязательные поля!";
    }

    QSqlQuery check;
    check.prepare("SELECT COUNT(*) FROM users WHERE login = :login");
    check.bindValue(":login", username.trimmed());
    if (check.exec() && check.next() && check.value(0).toInt() > 0) {
        return "Этот логин уже занят!";
    }

    QSqlQuery ins;
    ins.prepare("INSERT INTO users (login, password, role, full_name, group_id) "
                "VALUES (:login, :password, :role, :full_name, :group_id)");
    ins.bindValue(":login", username.trimmed());
    ins.bindValue(":password", password.trimmed());
    ins.bindValue(":role", role);
    ins.bindValue(":full_name", fullName.trimmed());
    if (role == "student" && groupId > 0)
        ins.bindValue(":group_id", groupId);
    else
        ins.bindValue(":group_id", QVariant());

    if (!ins.exec()) {
        return "Ошибка сохранения в БД!";
    }
    return "OK";
}

void AuthManager::logout() {
    m_userId = -1;
    m_userRole = "";
    m_fullName = "";
    m_groupName = "";
    emit authChanged();
}