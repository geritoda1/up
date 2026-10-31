import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#0f1115"

    Rectangle {
        width: 520; height: 520; radius: 260
        color: "#123b82f6"
        x: -120; y: -120
    }

    Rectangle {
        width: 460; height: 460; radius: 230
        color: "#0f6366f1"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: -100
        anchors.bottomMargin: -100
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // ШАПКА
        Rectangle {
            width: parent.width
            height: 64
            color: "#181b22"
            radius: 14
            border.color: "#282d37"

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter
                spacing: 14

                Rectangle {
                    width: 40; height: 40; radius: 10
                    color: "#1e293b"
                    border.color: "#3b82f6"
                    Text { text: "🏛️"; font.pixelSize: 18; anchors.centerIn: parent }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Text { text: "Панель управления деканата"; color: "#f8fafc"; font.pixelSize: 17; font.bold: true }
                    Text { text: "Администратор: " + authManager.fullName; color: "#94a3b8"; font.pixelSize: 12 }
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 18
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Rectangle {
                    height: 34; width: 105; radius: 8
                    color: "#111318"; border.color: "#242933"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: "Групп:"; color: "#94a3b8"; font.pixelSize: 12 }
                        Text { text: groupsList.count; color: "#60a5fa"; font.pixelSize: 13; font.bold: true }
                    }
                }

                Rectangle {
                    height: 34; width: 125; radius: 8
                    color: "#111318"; border.color: "#242933"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: "Предметов:"; color: "#94a3b8"; font.pixelSize: 12 }
                        Text { text: subjectsList.count; color: "#a78bfa"; font.pixelSize: 13; font.bold: true }
                    }
                }

                Rectangle {
                    height: 34; width: 125; radius: 8
                    color: "#111318"; border.color: "#242933"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: "Студентов:"; color: "#94a3b8"; font.pixelSize: 12 }
                        Text { text: studentsList.count; color: "#34d399"; font.pixelSize: 13; font.bold: true }
                    }
                }

                Button {
                    id: logoutBtn
                    width: 110; height: 36
                    hoverEnabled: true
                    text: "Выйти"
                    background: Rectangle {
                        radius: 8
                        color: logoutBtn.down ? "#7f1d1d" : (logoutBtn.hovered ? "#3f191d" : "#251418")
                        border.color: "#ef4444"
                    }
                    contentItem: Text {
                        text: logoutBtn.text
                        color: "#f87171"; font.pixelSize: 13; font.bold: true
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: authManager.logout()
                }
            }
        }

        // РАБОЧАЯ ОБЛАСТЬ В 3 КОЛОНКИ
        Row {
            width: parent.width
            height: parent.height - 80
            spacing: 16

            // КОЛОНКА 1: ГРУППЫ И ДИСЦИПЛИНЫ
            Rectangle {
                width: (parent.width - 32) * 0.31
                height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10

                    Text { text: "Учебные группы"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Row {
                        width: parent.width; spacing: 8

                        TextField {
                            id: groupInput
                            width: parent.width - 104; height: 38
                            placeholderText: "Например: ИСП-21"
                            color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                            leftPadding: 12; rightPadding: 12; selectByMouse: true
                            Keys.onReturnPressed: createGroupBtn.clicked()
                            background: Rectangle {
                                color: "#111318"; radius: 8
                                border.color: groupInput.activeFocus ? "#3b82f6" : "#282d37"
                            }
                        }

                        Button {
                            id: createGroupBtn
                            width: 96; height: 38
                            hoverEnabled: true
                            text: "+ Группа"
                            background: Rectangle {
                                radius: 8
                                color: createGroupBtn.down ? "#1d4ed8" : (createGroupBtn.hovered ? "#3b82f6" : "#2563eb")
                            }
                            contentItem: Text {
                                text: createGroupBtn.text
                                color: "#ffffff"; font.pixelSize: 13; font.bold: true
                                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                if (dbManager.addGroup(groupInput.text)) {
                                    groupInput.text = "";
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: parent.height * 0.30
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: groupsList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 4
                            model: dbManager.groupsModel

                            Text {
                                anchors.centerIn: parent
                                visible: groupsList.count === 0
                                text: "Группы еще не созданы"
                                color: "#64748b"; font.pixelSize: 12
                            }

                            delegate: Rectangle {
                                width: groupsList.width; height: 34; radius: 6
                                color: "#181b22"; border.color: "#242933"

                                Row {
                                    anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 6; spacing: 8

                                    Text {
                                        text: model.name || ""
                                        color: "#f8fafc"; font.pixelSize: 13; font.bold: true
                                        width: parent.width - 78; elide: Text.ElideRight
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Button {
                                        id: delGroupBtn
                                        width: 66; height: 24
                                        hoverEnabled: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Удалить"
                                        background: Rectangle {
                                            radius: 5
                                            color: delGroupBtn.down ? "#991b1b" : (delGroupBtn.hovered ? "#7f1d1d" : "#2b1619")
                                        }
                                        contentItem: Text {
                                            text: delGroupBtn.text; color: "#fca5a5"; font.pixelSize: 11
                                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                        }
                                        onClicked: dbManager.deleteGroup(model.id)
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#262b36" }

                    Text { text: "Дисциплины и нагрузка"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    TextField {
                        id: subjectInput
                        width: parent.width; height: 38
                        placeholderText: "Название предмета (напр. Базы данных)"
                        color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                        leftPadding: 12; rightPadding: 12; selectByMouse: true
                        background: Rectangle {
                            color: "#111318"; radius: 8
                            border.color: subjectInput.activeFocus ? "#3b82f6" : "#282d37"
                        }
                    }

                    ComboBox {
                        id: teacherCombo
                        width: parent.width; height: 38
                        model: dbManager.teachersModel
                        textRole: "full_name"
                        onCountChanged: { if (currentIndex === -1 && count > 0) currentIndex = 0; }

                        background: Rectangle {
                            color: "#111318"; radius: 8
                            border.color: teacherCombo.popup.visible ? "#3b82f6" : "#282d37"
                        }
                        contentItem: Text {
                            text: teacherCombo.count > 0 ? ("Преподаватель: " + teacherCombo.currentText) : "Сначала добавьте преподавателя →"
                            color: teacherCombo.count > 0 ? "#f8fafc" : "#64748b"
                            font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12; elide: Text.ElideRight
                        }
                        indicator: Text {
                            x: teacherCombo.width - width - 12; y: (teacherCombo.height - height) / 2
                            text: "▼"; color: "#64748b"; font.pixelSize: 10
                        }
                        delegate: ItemDelegate {
                            id: teacherDel
                            width: teacherCombo.width - 8; height: 34
                            highlighted: teacherCombo.highlightedIndex === index
                            contentItem: Text {
                                text: model.full_name || ""; color: "#f8fafc"; font.pixelSize: 13
                                verticalAlignment: Text.AlignVCenter; leftPadding: 10
                            }
                            background: Rectangle {
                                radius: 6; color: teacherDel.highlighted ? "#2563eb" : "transparent"
                            }
                        }
                        popup: Popup {
                            y: teacherCombo.height + 4; width: teacherCombo.width
                            implicitHeight: Math.min(180, contentItem.contentHeight + 8); padding: 4
                            contentItem: ListView {
                                clip: true; implicitHeight: contentHeight
                                model: teacherCombo.popup.visible ? teacherCombo.delegateModel : null
                            }
                            background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                        }
                    }

                    Button {
                        id: assignSubjectBtn
                        width: parent.width; height: 38
                        hoverEnabled: true
                        text: "Назначить дисциплину"
                        background: Rectangle {
                            radius: 8
                            color: assignSubjectBtn.down ? "#1d4ed8" : (assignSubjectBtn.hovered ? "#3b82f6" : "#2563eb")
                        }
                        contentItem: Text {
                            text: assignSubjectBtn.text; color: "#ffffff"; font.pixelSize: 13; font.bold: true
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            var tid = teacherCombo.count > 0 ? dbManager.getTeacherIdByIndex(teacherCombo.currentIndex) : -1;
                            if (dbManager.addSubject(subjectInput.text, tid)) {
                                subjectInput.text = "";
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: parent.height - 375
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: subjectsList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 4
                            model: dbManager.subjectsModel

                            Text {
                                anchors.centerIn: parent
                                visible: subjectsList.count === 0
                                text: "Дисциплины не добавлены"
                                color: "#64748b"; font.pixelSize: 12
                            }

                            delegate: Rectangle {
                                width: subjectsList.width; height: 42; radius: 6
                                color: "#181b22"; border.color: "#242933"

                                Row {
                                    anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 6; spacing: 8

                                    Column {
                                        width: parent.width - 78; anchors.verticalCenter: parent.verticalCenter; spacing: 1
                                        Text { text: model.title || ""; color: "#f8fafc"; font.pixelSize: 13; font.bold: true; width: parent.width; elide: Text.ElideRight }
                                        Text { text: "Ведет: " + (model.teacher_name || "Не назначен"); color: "#94a3b8"; font.pixelSize: 11; width: parent.width; elide: Text.ElideRight }
                                    }

                                    Button {
                                        id: delSubjBtn
                                        width: 66; height: 24
                                        hoverEnabled: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Удалить"
                                        background: Rectangle {
                                            radius: 5
                                            color: delSubjBtn.down ? "#991b1b" : (delSubjBtn.hovered ? "#7f1d1d" : "#2b1619")
                                        }
                                        contentItem: Text {
                                            text: delSubjBtn.text; color: "#fca5a5"; font.pixelSize: 11
                                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                        }
                                        onClicked: dbManager.deleteSubject(model.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // КОЛОНКА 2: СОЗДАНИЕ АККАУНТА
            Rectangle {
                width: (parent.width - 32) * 0.28
                height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 12

                    Text { text: "Регистрация пользователя"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }
                    Text {
                        text: "Добавление аккаунта студента или преподавателя напрямую в базу данных"
                        color: "#94a3b8"; font.pixelSize: 12; width: parent.width; wrapMode: Text.WordWrap
                    }

                    Column {
                        width: parent.width; spacing: 5
                        Text { text: "Роль пользователя"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                        ComboBox {
                            id: userRoleCombo
                            width: parent.width; height: 40
                            model: ["Студент", "Преподаватель"]
                            background: Rectangle { color: "#111318"; radius: 8; border.color: userRoleCombo.popup.visible ? "#3b82f6" : "#282d37" }
                            contentItem: Text { text: userRoleCombo.currentText; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                            indicator: Text { x: userRoleCombo.width - width - 12; y: (userRoleCombo.height - height) / 2; text: "▼"; color: "#64748b"; font.pixelSize: 10 }
                            delegate: ItemDelegate {
                                id: roleDel
                                width: userRoleCombo.width - 8; height: 34
                                highlighted: userRoleCombo.highlightedIndex === index
                                contentItem: Text { text: modelData; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                                background: Rectangle { radius: 6; color: roleDel.highlighted ? "#2563eb" : "transparent" }
                            }
                            popup: Popup {
                                y: userRoleCombo.height + 4; width: userRoleCombo.width; padding: 4
                                contentItem: ListView { clip: true; implicitHeight: contentHeight; model: userRoleCombo.popup.visible ? userRoleCombo.delegateModel : null }
                                background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                            }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 5
                        Text { text: "ФИО полностью"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            id: userFullName
                            width: parent.width; height: 40
                            placeholderText: "Например: Смирнов А.В."
                            color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                            leftPadding: 12; rightPadding: 12; selectByMouse: true
                            background: Rectangle { color: "#111318"; radius: 8; border.color: userFullName.activeFocus ? "#3b82f6" : "#282d37" }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 5
                        Text { text: "Логин для входа"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            id: userLogin
                            width: parent.width; height: 40
                            placeholderText: "Уникальный логин"
                            color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                            leftPadding: 12; rightPadding: 12; selectByMouse: true
                            background: Rectangle { color: "#111318"; radius: 8; border.color: userLogin.activeFocus ? "#3b82f6" : "#282d37" }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 5
                        Text { text: "Пароль"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            id: userPass
                            width: parent.width; height: 40
                            placeholderText: "Пароль от аккаунта"
                            color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                            leftPadding: 12; rightPadding: 12; selectByMouse: true
                            background: Rectangle { color: "#111318"; radius: 8; border.color: userPass.activeFocus ? "#3b82f6" : "#282d37" }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 5
                        visible: userRoleCombo.currentIndex === 0
                        Text { text: "Учебная группа студента"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                        ComboBox {
                            id: userGroupCombo
                            width: parent.width; height: 40
                            model: dbManager.groupsModel
                            textRole: "name"
                            onCountChanged: { if (currentIndex === -1 && count > 0) currentIndex = 0; }
                            background: Rectangle { color: "#111318"; radius: 8; border.color: userGroupCombo.popup.visible ? "#3b82f6" : "#282d37" }
                            contentItem: Text {
                                text: userGroupCombo.count > 0 ? userGroupCombo.currentText : "Групп пока нет (создайте слева)"
                                color: userGroupCombo.count > 0 ? "#f8fafc" : "#64748b"
                                font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12
                            }
                            indicator: Text { x: userGroupCombo.width - width - 12; y: (userGroupCombo.height - height) / 2; text: "▼"; color: "#64748b"; font.pixelSize: 10 }
                            delegate: ItemDelegate {
                                id: grpDel
                                width: userGroupCombo.width - 8; height: 34
                                highlighted: userGroupCombo.highlightedIndex === index
                                contentItem: Text { text: model.name || ""; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                                background: Rectangle { radius: 6; color: grpDel.highlighted ? "#2563eb" : "transparent" }
                            }
                            popup: Popup {
                                y: userGroupCombo.height + 4; width: userGroupCombo.width
                                implicitHeight: Math.min(180, contentItem.contentHeight + 8); padding: 4
                                contentItem: ListView { clip: true; implicitHeight: contentHeight; model: userGroupCombo.popup.visible ? userGroupCombo.delegateModel : null }
                                background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                            }
                        }
                    }

                    Rectangle {
                        id: userNotice
                        visible: false
                        width: parent.width; height: 34; radius: 8
                        property bool ok: true
                        color: ok ? "#1422c55e" : "#14ef4444"
                        border.color: ok ? "#22c55e" : "#ef4444"
                        Text {
                            id: userNoticeText
                            anchors.centerIn: parent
                            color: userNotice.ok ? "#4ade80" : "#f87171"
                            font.pixelSize: 12; font.bold: true
                        }
                    }

                    Button {
                        id: saveUserBtn
                        width: parent.width; height: 42
                        hoverEnabled: true
                        text: "Сохранить пользователя"
                        background: Rectangle {
                            radius: 8
                            color: saveUserBtn.down ? "#15803d" : (saveUserBtn.hovered ? "#22c55e" : "#16a34a")
                        }
                        contentItem: Text {
                            text: saveUserBtn.text; color: "#ffffff"; font.pixelSize: 13; font.bold: true
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            var role = userRoleCombo.currentIndex === 0 ? "student" : "teacher";
                            var gid = (role === "student" && userGroupCombo.count > 0)
                                      ? dbManager.getGroupIdByIndex(userGroupCombo.currentIndex) : -1;
                            if (dbManager.addUser(userLogin.text, userPass.text, role, userFullName.text, gid)) {
                                userFullName.text = "";
                                userLogin.text = "";
                                userPass.text = "";
                                userNotice.ok = true;
                                userNoticeText.text = "Аккаунт успешно добавлен!";
                                userNotice.visible = true;
                            } else {
                                userNotice.ok = false;
                                userNoticeText.text = "Заполните поля (логин уникален)";
                                userNotice.visible = true;
                            }
                        }
                    }
                }
            }

            // КОЛОНКА 3: СПИСКИ ПРЕПОДАВАТЕЛЕЙ И СТУДЕНТОВ
            Rectangle {
                width: (parent.width - 32) * 0.41
                height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10

                    Text { text: "Преподавательский состав"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Rectangle {
                        width: parent.width; height: parent.height * 0.34
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: teachersList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 5
                            model: dbManager.teachersModel

                            Text {
                                anchors.centerIn: parent
                                visible: teachersList.count === 0
                                text: "Список преподавателей пуст"
                                color: "#64748b"; font.pixelSize: 12
                            }

                            delegate: Rectangle {
                                width: teachersList.width; height: 40; radius: 7
                                color: "#181b22"; border.color: "#242933"

                                Row {
                                    anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 8; spacing: 8

                                    Column {
                                        width: parent.width - 80; anchors.verticalCenter: parent.verticalCenter
                                        Text { text: model.full_name || ""; color: "#f8fafc"; font.pixelSize: 13; font.bold: true; width: parent.width; elide: Text.ElideRight }
                                        Text { text: "Логин: " + (model.login || ""); color: "#60a5fa"; font.pixelSize: 11 }
                                    }

                                    Button {
                                        id: delTeacherBtn
                                        width: 68; height: 26
                                        hoverEnabled: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Удалить"
                                        background: Rectangle {
                                            radius: 5
                                            color: delTeacherBtn.down ? "#991b1b" : (delTeacherBtn.hovered ? "#7f1d1d" : "#2b1619")
                                        }
                                        contentItem: Text {
                                            text: delTeacherBtn.text; color: "#fca5a5"; font.pixelSize: 11
                                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                        }
                                        onClicked: dbManager.deleteUser(model.id)
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#262b36" }

                    Text { text: "Контингент студентов"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Rectangle {
                        width: parent.width
                        height: parent.height - (parent.height * 0.34) - 96
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: studentsList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 5
                            model: dbManager.studentsModel

                            Text {
                                anchors.centerIn: parent
                                visible: studentsList.count === 0
                                text: "Список студентов пуст"
                                color: "#64748b"; font.pixelSize: 12
                            }

                            delegate: Rectangle {
                                width: studentsList.width; height: 44; radius: 7
                                color: "#181b22"; border.color: "#242933"

                                Row {
                                    anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 8; spacing: 8

                                    Column {
                                        width: parent.width - 155; anchors.verticalCenter: parent.verticalCenter
                                        Text { text: model.full_name || ""; color: "#f8fafc"; font.pixelSize: 13; font.bold: true; width: parent.width; elide: Text.ElideRight }
                                        Text { text: "Логин: " + (model.login || ""); color: "#94a3b8"; font.pixelSize: 11 }
                                    }

                                    Rectangle {
                                        width: 68; height: 24; radius: 6
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "#1e293b"; border.color: "#334155"
                                        Text {
                                            anchors.centerIn: parent
                                            text: model.group_name || "—"
                                            color: "#38bdf8"; font.pixelSize: 11; font.bold: true
                                            width: parent.width - 8; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight
                                        }
                                    }

                                    Button {
                                        id: delStudentBtn
                                        width: 68; height: 26
                                        hoverEnabled: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Удалить"
                                        background: Rectangle {
                                            radius: 5
                                            color: delStudentBtn.down ? "#991b1b" : (delStudentBtn.hovered ? "#7f1d1d" : "#2b1619")
                                        }
                                        contentItem: Text {
                                            text: delStudentBtn.text; color: "#fca5a5"; font.pixelSize: 11
                                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                        }
                                        onClicked: dbManager.deleteUser(model.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}