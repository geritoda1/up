import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: mainWindow
    width: 1100
    height: 680
    minimumWidth: 960
    minimumHeight: 600
    visible: true
    title: "Учет посещаемости и успеваемости"
    color: "#0f1115"

    Connections {
        target: authManager
        function onAuthChanged() {
            if (authManager.userRole === "dean") {
                dbManager.refreshAll();
            } else if (authManager.userRole === "teacher") {
                dbManager.loadTeacherData(authManager.userId);
            } else if (authManager.userRole === "student") {
                dbManager.loadStudentData(authManager.userId);
            }
        }
    }

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: {
            if (authManager.userRole === "dean")
                return "AdminDashboard.qml";
            else if (authManager.userRole === "teacher")
                return "TeacherDashboard.qml";
            else if (authManager.userRole === "student")
                return "StudentDashboard.qml";
            else
                return "LoginView.qml";
        }
    }
}