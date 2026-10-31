#pragma once
#include <QObject>
#include <QString>

class AuthManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int userId READ userId NOTIFY authChanged)
    Q_PROPERTY(QString userRole READ userRole NOTIFY authChanged)
    Q_PROPERTY(QString fullName READ fullName NOTIFY authChanged)
    Q_PROPERTY(QString groupName READ groupName NOTIFY authChanged)

public:
    explicit AuthManager(QObject *parent = nullptr);

    int userId() const { return m_userId; }
    QString userRole() const { return m_userRole; }
    QString fullName() const { return m_fullName; }
    QString groupName() const { return m_groupName; }

    Q_INVOKABLE bool login(const QString &username, const QString &password);
    Q_INVOKABLE QString registerAccount(const QString &username, const QString &password,
                                        const QString &role, const QString &fullName, int groupId);
    Q_INVOKABLE void logout();

signals:
    void authChanged();

private:
    int m_userId = -1;
    QString m_userRole = "";
    QString m_fullName = "";
    QString m_groupName = "";
};