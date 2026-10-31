import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#0f1115"
    property bool isRegisterMode: false

    Rectangle {
        width: 480
        height: 480
        radius: 240
        color: "#1a3b82f6"
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -140
        anchors.verticalCenterOffset: -80
    }

    Rectangle {
        width: 420
        height: 420
        radius: 210
        color: "#126366f1"
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 150
        anchors.verticalCenterOffset: 90
    }

    Rectangle {
        id: card
        width: 400
        height: mainColumn.implicitHeight + 56
        anchors.centerIn: parent
        color: "#181b22"
        radius: 16
        border.color: "#282d37"
        border.width: 1

        Behavior on height {
            NumberAnimation { duration: 180; easing.type: Easing.OutQuad }
        }

        Column {
            id: mainColumn
            width: parent.width - 56
            anchors.centerIn: parent
            spacing: 14

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Учет успеваемости"
                    color: "#f8fafc"
                    font.pixelSize: 22
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: isRegisterMode ? "Регистрация нового пользователя" : "Вход в систему"
                    color: "#94a3b8"
                    font.pixelSize: 13
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 10
                color: "#111318"
                border.color: "#242933"

                Row {
                    anchors.fill: parent
                    anchors.margins: 4

                    Rectangle {
                        width: parent.width / 2
                        height: parent.height
                        radius: 7
                        color: !isRegisterMode ? "#2563eb" : "transparent"

                        Text {
                            text: "Вход"
                            anchors.centerIn: parent
                            color: !isRegisterMode ? "#ffffff" : "#94a3b8"
                            font.pixelSize: 13
                            font.bold: !isRegisterMode
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                isRegisterMode = false;
                                statusBanner.visible = false;
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width / 2
                        height: parent.height
                        radius: 7
                        color: isRegisterMode ? "#2563eb" : "transparent"

                        Text {
                            text: "Регистрация"
                            anchors.centerIn: parent
                            color: isRegisterMode ? "#ffffff" : "#94a3b8"
                            font.pixelSize: 13
                            font.bold: isRegisterMode
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                isRegisterMode = true;
                                statusBanner.visible = false;
                            }
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5
                visible: isRegisterMode

                Text {
                    text: "ФИО"
                    color: "#cbd5e1"
                    font.pixelSize: 12
                    font.bold: true
                }

                TextField {
                    id: fullNameField
                    width: parent.width
                    height: 42
                    placeholderText: "Иванов Иван Иванович"
                    color: "#f8fafc"
                    placeholderTextColor: "#64748b"
                    font.pixelSize: 14
                    leftPadding: 14
                    rightPadding: 14
                    selectByMouse: true
                    background: Rectangle {
                        color: "#111318"
                        radius: 8
                        border.color: fullNameField.activeFocus ? "#3b82f6" : "#282d37"
                        border.width: fullNameField.activeFocus ? 1.5 : 1
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5

                Text {
                    text: "Логин"
                    color: "#cbd5e1"
                    font.pixelSize: 12
                    font.bold: true
                }

                TextField {
                    id: loginField
                    width: parent.width
                    height: 42
                    placeholderText: "Введите логин"
                    color: "#f8fafc"
                    placeholderTextColor: "#64748b"
                    font.pixelSize: 14
                    leftPadding: 14
                    rightPadding: 14
                    selectByMouse: true
                    Keys.onReturnPressed: submitAction()
                    background: Rectangle {
                        color: "#111318"
                        radius: 8
                        border.color: loginField.activeFocus ? "#3b82f6" : "#282d37"
                        border.width: loginField.activeFocus ? 1.5 : 1
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5

                Text {
                    text: "Пароль"
                    color: "#cbd5e1"
                    font.pixelSize: 12
                    font.bold: true
                }

                TextField {
                    id: passField
                    width: parent.width
                    height: 42
                    placeholderText: "Введите пароль"
                    echoMode: TextInput.Password
                    color: "#f8fafc"
                    placeholderTextColor: "#64748b"
                    font.pixelSize: 14
                    leftPadding: 14
                    rightPadding: 14
                    selectByMouse: true
                    Keys.onReturnPressed: submitAction()
                    background: Rectangle {
                        color: "#111318"
                        radius: 8
                        border.color: passField.activeFocus ? "#3b82f6" : "#282d37"
                        border.width: passField.activeFocus ? 1.5 : 1
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5
                visible: isRegisterMode

                Text {
                    text: "Роль"
                    color: "#cbd5e1"
                    font.pixelSize: 12
                    font.bold: true
                }

                ComboBox {
                    id: roleCombo
                    width: parent.width
                    height: 42
                    model: ["Студент", "Преподаватель"]

                    background: Rectangle {
                        color: "#111318"
                        radius: 8
                        border.color: roleCombo.popup.visible ? "#3b82f6" : "#282d37"
                    }

                    contentItem: Text {
                        text: roleCombo.currentText
                        color: "#f8fafc"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 14
                    }

                    indicator: Text {
                        x: roleCombo.width - width - 14
                        y: (roleCombo.height - height) / 2
                        text: "▼"
                        color: "#64748b"
                        font.pixelSize: 11
                    }

                    delegate: ItemDelegate {
                        id: roleItemDel
                        width: roleCombo.width - 8
                        height: 36
                        highlighted: roleCombo.highlightedIndex === index

                        contentItem: Text {
                            text: modelData
                            color: "#f8fafc"
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }

                        background: Rectangle {
                            radius: 6
                            color: roleItemDel.highlighted ? "#2563eb" : "transparent"
                        }
                    }

                    popup: Popup {
                        y: roleCombo.height + 4
                        width: roleCombo.width
                        padding: 4

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: roleCombo.popup.visible ? roleCombo.delegateModel : null
                        }

                        background: Rectangle {
                            color: "#181b22"
                            border.color: "#3b82f6"
                            radius: 8
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5
                visible: isRegisterMode && roleCombo.currentIndex === 0

                Text {
                    text: "Группа"
                    color: "#cbd5e1"
                    font.pixelSize: 12
                    font.bold: true
                }

                ComboBox {
                    id: regGroupCombo
                    width: parent.width
                    height: 42
                    model: dbManager.groupsModel
                    textRole: "name"

                    onCountChanged: {
                        if (currentIndex === -1 && count > 0)
                            currentIndex = 0;
                    }

                    background: Rectangle {
                        color: "#111318"
                        radius: 8
                        border.color: regGroupCombo.popup.visible ? "#3b82f6" : "#282d37"
                    }

                    contentItem: Text {
                        text: regGroupCombo.count > 0 ? regGroupCombo.currentText : "Нет доступных групп"
                        color: regGroupCombo.count > 0 ? "#f8fafc" : "#64748b"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 14
                    }

                    indicator: Text {
                        x: regGroupCombo.width - width - 14
                        y: (regGroupCombo.height - height) / 2
                        text: "▼"
                        color: "#64748b"
                        font.pixelSize: 11
                    }

                    delegate: ItemDelegate {
                        id: regGroupDel
                        width: regGroupCombo.width - 8
                        height: 36
                        highlighted: regGroupCombo.highlightedIndex === index

                        contentItem: Text {
                            text: model.name || ""
                            color: "#f8fafc"
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }

                        background: Rectangle {
                            radius: 6
                            color: regGroupDel.highlighted ? "#2563eb" : "transparent"
                        }
                    }

                    popup: Popup {
                        y: regGroupCombo.height + 4
                        width: regGroupCombo.width
                        implicitHeight: Math.min(180, contentItem.contentHeight + 8)
                        padding: 4

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: regGroupCombo.popup.visible ? regGroupCombo.delegateModel : null
                        }

                        background: Rectangle {
                            color: "#181b22"
                            border.color: "#3b82f6"
                            radius: 8
                        }
                    }
                }
            }

            Rectangle {
                id: statusBanner
                visible: false
                width: parent.width
                height: 36
                radius: 8
                property bool isSuccess: false
                color: isSuccess ? "#1422c55e" : "#14ef4444"
                border.color: isSuccess ? "#22c55e" : "#ef4444"

                Text {
                    id: statusText
                    anchors.centerIn: parent
                    color: statusBanner.isSuccess ? "#4ade80" : "#f87171"
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Button {
                id: submitBtn
                width: parent.width
                height: 44
                hoverEnabled: true
                text: isRegisterMode ? "Зарегистрироваться" : "Войти"

                background: Rectangle {
                    radius: 8
                    color: submitBtn.down ? "#1d4ed8" : (submitBtn.hovered ? "#3b82f6" : "#2563eb")
                }

                contentItem: Text {
                    text: submitBtn.text
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: submitAction()
            }
        }
    }

    function submitAction() {
        statusBanner.visible = false;
        if (!isRegisterMode) {
            if (!authManager.login(loginField.text, passField.text)) {
                statusBanner.isSuccess = false;
                statusText.text = "Неверный логин или пароль";
                statusBanner.visible = true;
            }
        } else {
            var roleCode = roleCombo.currentIndex === 0 ? "student" : "teacher";
            var gid = (roleCode === "student" && regGroupCombo.count > 0)
                      ? dbManager.getGroupIdByIndex(regGroupCombo.currentIndex) : -1;
            var res = authManager.registerAccount(loginField.text, passField.text, roleCode, fullNameField.text, gid);
            if (res === "OK") {
                dbManager.refreshAll();
                isRegisterMode = false;
                fullNameField.text = "";
                passField.text = "";
                statusBanner.isSuccess = true;
                statusText.text = "Аккаунт создан";
                statusBanner.visible = true;
            } else {
                statusBanner.isSuccess = false;
                statusText.text = res;
                statusBanner.visible = true;
            }
        }
    }
}