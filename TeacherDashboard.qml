import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#0f1115"

    property int selectedRecordId: -1
    property string boundStudentName: "Не выбрано"
    property string boundDate: Qt.formatDate(new Date(), "yyyy-MM-dd")
    property string boundAttendance: "Присутствовал"
    property string boundGrade: ""

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

        Rectangle {
            width: parent.width; height: 64
            color: "#181b22"; radius: 14; border.color: "#282d37"

            Column {
                anchors.left: parent.left; anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter; spacing: 2
                Text { text: "Журнал преподавателя"; color: "#f8fafc"; font.pixelSize: 17; font.bold: true }
                Text { text: authManager.fullName; color: "#94a3b8"; font.pixelSize: 12 }
            }

            Row {
                anchors.right: parent.right; anchors.rightMargin: 18
                anchors.verticalCenter: parent.verticalCenter; spacing: 10

                Rectangle {
                    height: 34; width: 130; radius: 8
                    color: "#111318"; border.color: "#242933"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: "Записей:"; color: "#94a3b8"; font.pixelSize: 12 }
                        Text { text: journalList.count; color: "#60a5fa"; font.pixelSize: 13; font.bold: true }
                    }
                }

                Rectangle {
                    height: 34; width: 130; radius: 8
                    color: "#111318"; border.color: "#242933"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: "Предметов:"; color: "#94a3b8"; font.pixelSize: 12 }
                        Text { text: subjectCombo.count; color: "#a78bfa"; font.pixelSize: 13; font.bold: true }
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
                        text: logoutBtn.text; color: "#f87171"; font.pixelSize: 13; font.bold: true
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: authManager.logout()
                }
            }
        }

        Row {
            width: parent.width; height: parent.height - 80; spacing: 16

            Rectangle {
                width: (parent.width - 16) * 0.65
                height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 12

                    Text { text: "Учет посещаемости и оценок"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Rectangle {
                        width: parent.width; height: 38
                        color: "#111318"; radius: 8; border.color: "#242933"

                        Row {
                            anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 8
                            Text { text: "Студент"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.27; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Группа"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.13; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Дисциплина"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.23; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Дата"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.13; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Посещаемость"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.14; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Оценка"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.08; horizontalAlignment: Text.AlignHCenter; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: parent.height - 96
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: journalList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 5
                            model: dbManager.journalModel

                            Text {
                                anchors.centerIn: parent
                                visible: journalList.count === 0
                                text: "Записей пока нет"
                                color: "#64748b"; font.pixelSize: 13; horizontalAlignment: Text.AlignHCenter
                            }

                            delegate: Rectangle {
                                id: rowDelegate
                                width: journalList.width; height: 44; radius: 8
                                property bool isSelected: selectedRecordId === model.id
                                color: isSelected ? "#1e293b" : (rowMouse.containsMouse ? "#1c2029" : "#181b22")
                                border.color: isSelected ? "#3b82f6" : "#242933"
                                border.width: isSelected ? 1.5 : 1

                                Row {
                                    anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 8

                                    Text {
                                        text: model.student_name || ""
                                        color: "#f8fafc"; font.pixelSize: 13; font.bold: rowDelegate.isSelected
                                        width: parent.width * 0.27; elide: Text.ElideRight
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Item {
                                        width: parent.width * 0.13; height: parent.height
                                        Rectangle {
                                            height: 24; width: Math.min(parent.width - 4, groupText.implicitWidth + 14); radius: 6
                                            anchors.verticalCenter: parent.verticalCenter
                                            color: "#1e293b"; border.color: "#334155"
                                            Text { id: groupText; anchors.centerIn: parent; text: model.group_name || "—"; color: "#38bdf8"; font.pixelSize: 11; font.bold: true }
                                        }
                                    }

                                    Text {
                                        text: model.subject_title || ""
                                        color: "#cbd5e1"; font.pixelSize: 12
                                        width: parent.width * 0.23; elide: Text.ElideRight
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: model.lesson_date || ""
                                        color: "#94a3b8"; font.pixelSize: 12
                                        width: parent.width * 0.13
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Item {
                                        width: parent.width * 0.14; height: parent.height
                                        Rectangle {
                                            height: 24; width: parent.width - 4; radius: 6
                                            anchors.verticalCenter: parent.verticalCenter
                                            color: model.attendance === "Присутствовал" ? "#1422c55e" : (model.attendance === "Прогул" ? "#14ef4444" : "#14eab308")
                                            border.color: model.attendance === "Присутствовал" ? "#22c55e" : (model.attendance === "Прогул" ? "#ef4444" : "#eab308")
                                            Text {
                                                anchors.centerIn: parent; text: model.attendance || ""
                                                color: model.attendance === "Присутствовал" ? "#4ade80" : (model.attendance === "Прогул" ? "#f87171" : "#facc15")
                                                font.pixelSize: 11; font.bold: true
                                            }
                                        }
                                    }

                                    Item {
                                        width: parent.width * 0.08; height: parent.height
                                        Rectangle {
                                            width: 28; height: 28; radius: 6; anchors.centerIn: parent
                                            property string g: model.grade || ""
                                            color: g === "5" ? "#1422c55e" : (g === "4" ? "#143b82f6" : (g === "3" ? "#14eab308" : (g === "2" ? "#14ef4444" : "#111318")))
                                            border.color: g === "5" ? "#22c55e" : (g === "4" ? "#3b82f6" : (g === "3" ? "#eab308" : (g === "2" ? "#ef4444" : "#282d37")))
                                            Text { anchors.centerIn: parent; text: (model.grade && model.grade !== "") ? model.grade : "—"; color: "#f8fafc"; font.pixelSize: 13; font.bold: true }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: rowMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        selectedRecordId = model.id;
                                        boundStudentName = model.student_name;
                                        boundDate = model.lesson_date;
                                        boundGrade = model.grade;
                                        boundAttendance = model.attendance;
                                        dateField.text = model.lesson_date;
                                        gradeField.text = model.grade;
                                        var attIdx = attendanceCombo.find(model.attendance);
                                        if (attIdx !== -1) attendanceCombo.currentIndex = attIdx;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: (parent.width - 16) * 0.35
                height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10

                    Text { text: "Параметры записи"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Студент"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                        ComboBox {
                            id: studentCombo
                            width: parent.width; height: 38
                            model: dbManager.studentsModel
                            textRole: "full_name"
                            onCountChanged: { if (currentIndex === -1 && count > 0) currentIndex = 0; }
                            background: Rectangle { color: "#111318"; radius: 8; border.color: studentCombo.popup.visible ? "#3b82f6" : "#282d37" }
                            contentItem: Text {
                                text: studentCombo.count > 0 ? studentCombo.currentText : "Нет студентов"
                                color: studentCombo.count > 0 ? "#f8fafc" : "#64748b"
                                font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12; elide: Text.ElideRight
                            }
                            indicator: Text { x: studentCombo.width - width - 12; y: (studentCombo.height - height) / 2; text: "▼"; color: "#64748b"; font.pixelSize: 10 }
                            delegate: ItemDelegate {
                                id: stDel
                                width: studentCombo.width - 8; height: 34
                                highlighted: studentCombo.highlightedIndex === index
                                contentItem: Text { text: (model.full_name || "") + " (" + (model.group_name || "") + ")"; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                                background: Rectangle { radius: 6; color: stDel.highlighted ? "#2563eb" : "transparent" }
                            }
                            popup: Popup {
                                y: studentCombo.height + 4; width: studentCombo.width
                                implicitHeight: Math.min(200, contentItem.contentHeight + 8); padding: 4
                                contentItem: ListView { clip: true; implicitHeight: contentHeight; model: studentCombo.popup.visible ? studentCombo.delegateModel : null }
                                background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                            }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Дисциплина"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                        ComboBox {
                            id: subjectCombo
                            width: parent.width; height: 38
                            model: dbManager.subjectsModel
                            textRole: "title"
                            onCountChanged: { if (currentIndex === -1 && count > 0) currentIndex = 0; }
                            background: Rectangle { color: "#111318"; radius: 8; border.color: subjectCombo.popup.visible ? "#3b82f6" : "#282d37" }
                            contentItem: Text {
                                text: subjectCombo.count > 0 ? subjectCombo.currentText : "Нет дисциплин"
                                color: subjectCombo.count > 0 ? "#f8fafc" : "#64748b"
                                font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12; elide: Text.ElideRight
                            }
                            indicator: Text { x: subjectCombo.width - width - 12; y: (subjectCombo.height - height) / 2; text: "▼"; color: "#64748b"; font.pixelSize: 10 }
                            delegate: ItemDelegate {
                                id: subDel
                                width: subjectCombo.width - 8; height: 34
                                highlighted: subjectCombo.highlightedIndex === index
                                contentItem: Text { text: model.title || ""; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                                background: Rectangle { radius: 6; color: subDel.highlighted ? "#2563eb" : "transparent" }
                            }
                            popup: Popup {
                                y: subjectCombo.height + 4; width: subjectCombo.width
                                implicitHeight: Math.min(200, contentItem.contentHeight + 8); padding: 4
                                contentItem: ListView { clip: true; implicitHeight: contentHeight; model: subjectCombo.popup.visible ? subjectCombo.delegateModel : null }
                                background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#262b36" }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Выбранная запись"; color: selectedRecordId > 0 ? "#60a5fa" : "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            id: selectedStudentText
                            width: parent.width; height: 36; readOnly: true
                            text: selectedRecordId > 0 ? ("#" + selectedRecordId + " • " + boundStudentName) : boundStudentName
                            color: selectedRecordId > 0 ? "#60a5fa" : "#64748b"; font.pixelSize: 13
                            leftPadding: 12; rightPadding: 12
                            background: Rectangle { color: "#111318"; radius: 8; border.color: selectedRecordId > 0 ? "#3b82f6" : "#242933" }
                        }
                    }

                    Row {
                        width: parent.width; spacing: 10

                        Column {
                            width: (parent.width - 10) * 0.48; spacing: 4
                            Text { text: "Дата"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                            TextField {
                                id: dateField
                                width: parent.width; height: 38
                                text: boundDate; placeholderText: "ГГГГ-ММ-ДД"
                                color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                                leftPadding: 12; rightPadding: 12; selectByMouse: true
                                background: Rectangle { color: "#111318"; radius: 8; border.color: dateField.activeFocus ? "#3b82f6" : "#282d37" }
                            }
                        }

                        Column {
                            width: (parent.width - 10) * 0.52; spacing: 4
                            Text { text: "Посещаемость"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                            ComboBox {
                                id: attendanceCombo
                                width: parent.width; height: 38
                                model: ["Присутствовал", "Прогул", "Болел"]
                                background: Rectangle { color: "#111318"; radius: 8; border.color: attendanceCombo.popup.visible ? "#3b82f6" : "#282d37" }
                                contentItem: Text { text: attendanceCombo.currentText; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                                indicator: Text { x: attendanceCombo.width - width - 10; y: (attendanceCombo.height - height) / 2; text: "▼"; color: "#64748b"; font.pixelSize: 10 }
                                delegate: ItemDelegate {
                                    id: attDel
                                    width: attendanceCombo.width - 8; height: 34
                                    highlighted: attendanceCombo.highlightedIndex === index
                                    contentItem: Text { text: modelData; color: "#f8fafc"; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                                    background: Rectangle { radius: 6; color: attDel.highlighted ? "#2563eb" : "transparent" }
                                }
                                popup: Popup {
                                    y: attendanceCombo.height + 4; width: attendanceCombo.width; padding: 4
                                    contentItem: ListView { clip: true; implicitHeight: contentHeight; model: attendanceCombo.popup.visible ? attendanceCombo.delegateModel : null }
                                    background: Rectangle { color: "#181b22"; border.color: "#3b82f6"; radius: 8 }
                                }
                            }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Оценка"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }

                        Row {
                            width: parent.width; spacing: 6

                            TextField {
                                id: gradeField
                                width: parent.width - 194; height: 38
                                text: boundGrade; placeholderText: "Без оценки"
                                color: "#f8fafc"; placeholderTextColor: "#64748b"; font.pixelSize: 13
                                leftPadding: 12; rightPadding: 12; selectByMouse: true
                                background: Rectangle { color: "#111318"; radius: 8; border.color: gradeField.activeFocus ? "#3b82f6" : "#282d37" }
                            }

                            Repeater {
                                model: ["5", "4", "3", "2", ""]
                                Button {
                                    id: gradeQuickBtn
                                    width: 32; height: 38
                                    hoverEnabled: true
                                    property string val: modelData
                                    text: val === "" ? "—" : val
                                    background: Rectangle {
                                        radius: 7
                                        color: gradeField.text === gradeQuickBtn.val ? "#2563eb" : (gradeQuickBtn.hovered ? "#1e293b" : "#111318")
                                        border.color: gradeField.text === gradeQuickBtn.val ? "#3b82f6" : "#282d37"
                                    }
                                    contentItem: Text {
                                        text: gradeQuickBtn.text; color: "#f8fafc"; font.pixelSize: 13; font.bold: true
                                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: gradeField.text = gradeQuickBtn.val
                                }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#262b36" }

                    Button {
                        id: insertBtn
                        width: parent.width; height: 40
                        hoverEnabled: true
                        text: "Добавить запись"
                        enabled: studentCombo.count > 0 && subjectCombo.count > 0
                        background: Rectangle {
                            radius: 8
                            color: !insertBtn.enabled ? "#1f242d" : (insertBtn.down ? "#15803d" : (insertBtn.hovered ? "#22c55e" : "#16a34a"))
                        }
                        contentItem: Text {
                            text: insertBtn.text; color: insertBtn.enabled ? "#ffffff" : "#64748b"
                            font.pixelSize: 13; font.bold: true
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            var sid = dbManager.getStudentIdByIndex(studentCombo.currentIndex);
                            var subid = dbManager.getSubjectIdByIndex(subjectCombo.currentIndex);
                            dbManager.addJournalRecord(sid, subid, dateField.text, attendanceCombo.currentText, gradeField.text);
                        }
                    }

                    Button {
                        id: updateBtn
                        width: parent.width; height: 40
                        hoverEnabled: true
                        text: "Сохранить изменения"
                        enabled: selectedRecordId > 0
                        background: Rectangle {
                            radius: 8
                            color: !updateBtn.enabled ? "#1f242d" : (updateBtn.down ? "#1d4ed8" : (updateBtn.hovered ? "#3b82f6" : "#2563eb"))
                        }
                        contentItem: Text {
                            text: updateBtn.text; color: updateBtn.enabled ? "#ffffff" : "#64748b"
                            font.pixelSize: 13; font.bold: true
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            dbManager.updateJournalRecord(selectedRecordId, dateField.text, attendanceCombo.currentText, gradeField.text);
                        }
                    }

                    Button {
                        id: deleteBtn
                        width: parent.width; height: 38
                        hoverEnabled: true
                        text: "Удалить запись"
                        enabled: selectedRecordId > 0
                        background: Rectangle {
                            radius: 8
                            color: !deleteBtn.enabled ? "#1f242d" : (deleteBtn.down ? "#7f1d1d" : (deleteBtn.hovered ? "#991b1b" : "#3f191d"))
                            border.color: deleteBtn.enabled ? "#ef4444" : "transparent"
                        }
                        contentItem: Text {
                            text: deleteBtn.text; color: deleteBtn.enabled ? "#fca5a5" : "#64748b"
                            font.pixelSize: 13; font.bold: true
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            dbManager.deleteJournalRecord(selectedRecordId);
                            selectedRecordId = -1;
                            boundStudentName = "Не выбрано";
                            gradeField.text = "";
                        }
                    }
                }
            }
        }
    }
}