import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#0f1115"

    property int selectedId: -1
    property string selSubject: "Не выбрано"
    property string selTeacher: "—"
    property string selDate: "—"
    property string selAttendance: "—"
    property string selGrade: "—"
    property string currentFilter: "Все"

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
                Text { text: "Личный кабинет студента"; color: "#f8fafc"; font.pixelSize: 17; font.bold: true }
                Row {
                    spacing: 8
                    Text { text: authManager.fullName; color: "#94a3b8"; font.pixelSize: 12 }
                    Text { text: "•"; color: "#475569"; font.pixelSize: 12 }
                    Text { text: "Группа: " + authManager.groupName; color: "#38bdf8"; font.pixelSize: 12; font.bold: true }
                }
            }

            Row {
                anchors.right: parent.right; anchors.rightMargin: 18
                anchors.verticalCenter: parent.verticalCenter; spacing: 10

                Button {
                    id: refreshBtn
                    width: 110; height: 36
                    hoverEnabled: true
                    text: "Обновить"
                    background: Rectangle {
                        radius: 8
                        color: refreshBtn.down ? "#1e293b" : (refreshBtn.hovered ? "#242c3d" : "#111318")
                        border.color: "#334155"
                    }
                    contentItem: Text {
                        text: refreshBtn.text; color: "#cbd5e1"; font.pixelSize: 13; font.bold: true
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: dbManager.loadStudentData(authManager.userId)
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
            width: parent.width; height: 82; spacing: 16

            Rectangle {
                width: (parent.width - 32) / 3; height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"
                Column {
                    anchors.left: parent.left; anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: "Средний балл"; color: "#94a3b8"; font.pixelSize: 12 }
                    Text { text: dbManager.studentAvgGrade; color: "#4ade80"; font.pixelSize: 22; font.bold: true }
                }
            }

            Rectangle {
                width: (parent.width - 32) / 3; height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"
                Column {
                    anchors.left: parent.left; anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: "Посещаемость"; color: "#94a3b8"; font.pixelSize: 12 }
                    Text { text: dbManager.studentAttendancePercent; color: "#60a5fa"; font.pixelSize: 22; font.bold: true }
                }
            }

            Rectangle {
                width: (parent.width - 32) / 3; height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"
                Column {
                    anchors.left: parent.left; anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: "Всего занятий"; color: "#94a3b8"; font.pixelSize: 12 }
                    Text { text: studentList.count; color: "#c084fc"; font.pixelSize: 22; font.bold: true }
                }
            }
        }

        Row {
            width: parent.width; height: parent.height - 178; spacing: 16

            Rectangle {
                width: (parent.width - 16) * 0.70; height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 12

                    Row {
                        width: parent.width; height: 32; spacing: 8

                        Text {
                            text: "Дневник"
                            color: "#f8fafc"; font.pixelSize: 15; font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item { width: 16; height: 1 }

                        Repeater {
                            model: ["Все", "Присутствовал", "Прогул", "Болел"]

                            Button {
                                id: filterBtn
                                height: 28
                                width: filterLabel.implicitWidth + 22
                                hoverEnabled: true
                                anchors.verticalCenter: parent.verticalCenter
                                property bool active: root.currentFilter === modelData

                                background: Rectangle {
                                    radius: 6
                                    color: filterBtn.active ? "#2563eb" : (filterBtn.hovered ? "#1e293b" : "#111318")
                                    border.color: filterBtn.active ? "#3b82f6" : "#282d37"
                                }

                                contentItem: Text {
                                    id: filterLabel
                                    text: modelData
                                    color: filterBtn.active ? "#ffffff" : "#94a3b8"
                                    font.pixelSize: 12; font.bold: filterBtn.active
                                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: root.currentFilter = modelData
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: 38
                        color: "#111318"; radius: 8; border.color: "#242933"

                        Row {
                            anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 10
                            Text { text: "Дисциплина"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.30; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Преподаватель"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.26; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Дата"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.15; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Статус"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.16; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Оценка"; color: "#94a3b8"; font.pixelSize: 12; font.bold: true; width: parent.width * 0.08; horizontalAlignment: Text.AlignHCenter; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: parent.height - 104
                        color: "#111318"; radius: 10; border.color: "#222630"

                        ListView {
                            id: studentList
                            anchors.fill: parent; anchors.margins: 6
                            clip: true; spacing: 5
                            model: dbManager.studentJournalModel

                            Text {
                                anchors.centerIn: parent
                                visible: studentList.count === 0
                                text: "Записей пока нет"
                                color: "#64748b"; font.pixelSize: 13; horizontalAlignment: Text.AlignHCenter
                            }

                            delegate: Item {
                                property bool matchesFilter: root.currentFilter === "Все" || model.attendance === root.currentFilter
                                width: studentList.width
                                height: matchesFilter ? 44 : 0
                                visible: matchesFilter
                                clip: true

                                Rectangle {
                                    anchors.fill: parent; radius: 8
                                    property bool isSelected: root.selectedId === model.id
                                    color: isSelected ? "#1e293b" : (itemMouse.containsMouse ? "#1c2029" : "#181b22")
                                    border.color: isSelected ? "#3b82f6" : "#242933"
                                    border.width: isSelected ? 1.5 : 1

                                    Row {
                                        anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 10

                                        Text { text: model.subject_title || ""; color: "#f8fafc"; font.pixelSize: 13; font.bold: true; width: parent.width * 0.30; elide: Text.ElideRight; anchors.verticalCenter: parent.verticalCenter }
                                        Text { text: model.teacher_name || "—"; color: "#cbd5e1"; font.pixelSize: 12; width: parent.width * 0.26; elide: Text.ElideRight; anchors.verticalCenter: parent.verticalCenter }
                                        Text { text: model.lesson_date || ""; color: "#94a3b8"; font.pixelSize: 12; width: parent.width * 0.15; anchors.verticalCenter: parent.verticalCenter }

                                        Item {
                                            width: parent.width * 0.16; height: parent.height
                                            Rectangle {
                                                height: 24; width: parent.width - 6; radius: 6
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
                                        id: itemMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.selectedId = model.id;
                                            root.selSubject = model.subject_title || "—";
                                            root.selTeacher = model.teacher_name || "—";
                                            root.selDate = model.lesson_date || "—";
                                            root.selAttendance = model.attendance || "—";
                                            root.selGrade = (model.grade && model.grade !== "") ? model.grade : "Без оценки";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: (parent.width - 16) * 0.30; height: parent.height
                color: "#181b22"; radius: 14; border.color: "#282d37"

                Column {
                    anchors.fill: parent; anchors.margins: 16; spacing: 12

                    Text { text: "Детали занятия"; color: "#f8fafc"; font.pixelSize: 15; font.bold: true }

                    Rectangle { width: parent.width; height: 1; color: "#262b36" }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Дисциплина"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            width: parent.width; height: 38; readOnly: true; text: root.selSubject
                            color: "#f8fafc"; font.pixelSize: 13; leftPadding: 12; rightPadding: 12
                            background: Rectangle { color: "#111318"; radius: 8; border.color: "#282d37" }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Преподаватель"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            width: parent.width; height: 38; readOnly: true; text: root.selTeacher
                            color: "#f8fafc"; font.pixelSize: 13; leftPadding: 12; rightPadding: 12
                            background: Rectangle { color: "#111318"; radius: 8; border.color: "#282d37" }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 4
                        Text { text: "Дата"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                        TextField {
                            width: parent.width; height: 38; readOnly: true; text: root.selDate
                            color: "#60a5fa"; font.pixelSize: 13; font.bold: true; leftPadding: 12; rightPadding: 12
                            background: Rectangle { color: "#111318"; radius: 8; border.color: "#282d37" }
                        }
                    }

                    Row {
                        width: parent.width; spacing: 10

                        Column {
                            width: (parent.width - 10) * 0.55; spacing: 4
                            Text { text: "Посещаемость"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                            TextField {
                                width: parent.width; height: 38; readOnly: true; text: root.selAttendance
                                color: root.selAttendance === "Присутствовал" ? "#4ade80" : (root.selAttendance === "Прогул" ? "#f87171" : "#facc15")
                                font.pixelSize: 13; font.bold: true; leftPadding: 12; rightPadding: 12
                                background: Rectangle { color: "#111318"; radius: 8; border.color: "#282d37" }
                            }
                        }

                        Column {
                            width: (parent.width - 10) * 0.45; spacing: 4
                            Text { text: "Оценка"; color: "#cbd5e1"; font.pixelSize: 12; font.bold: true }
                            TextField {
                                width: parent.width; height: 38; readOnly: true; text: root.selGrade
                                color: "#f8fafc"; font.pixelSize: 13; font.bold: true; leftPadding: 12; rightPadding: 12
                                background: Rectangle { color: "#111318"; radius: 8; border.color: "#282d37" }
                            }
                        }
                    }
                }
            }
        }
    }
}