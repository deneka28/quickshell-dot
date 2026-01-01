import QtQuick
import QtQuick.Window
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import qs

Rectangle {
    id: root

    property int month: selectedDate.getMonth()
    property int year: selectedDate.getFullYear()
    property int day: selectedDate.getDate()
    property int weekday: selectedDate.getDay()
    property int daysInMonth: new Date(year, month + 1, 0).getDate()

    property date selectedDate: new Date()

    property int _start_weekday: new Date(year, month, 1).getDay()

    implicitWidth: parent.width
    implicitHeight: parent.height
    color: "transparent"

    ColumnLayout {
        id: layout

        Rectangle {
            id: title
            implicitHeight: 40
            implicitWidth: 200
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignCenter
            color: "transparent"

            Text {
                anchors.fill: parent
                anchors.centerIn: parent
                text: root.selectedDate.toLocaleDateString(Qt.locale(), "ddd, yyyy.MM.dd")
                font.pixelSize: 30
                color: Config.colors.fontcolor
            }
        }

        Rectangle {
            id: controls
            color: "transparent"
            implicitHeight: 40
            implicitWidth: 200
            Layout.alignment: Qt.AlignCenter

            RowLayout {
                anchors.fill: parent
                Layout.fillWidth: true
                anchors.horizontalCenter: controls.horizontalCenter


                CalendarButton {
                    id: back
                    buttonWidth: 25
                    buttonHeight: 25
                    color: "transparent"
                    iconSource: Quickshell.iconPath("go-previous-symbolic")
                    onButtonClicked: root.set_month(root.month - 1)
                }
                Rectangle {
                    implicitWidth: 140
                    implicitHeight: parent.height
                    color: "transparent"
                    Layout.alignment: Qt.AlignCenter
                    Text {
                        anchors.centerIn: parent
                        text: root.selectedDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
                        font.pixelSize: 18
                        color: Config.colors.fontcolor
                        Layout.alignment: Qt.AlignCenter

                        MouseArea {
                            id: area
                            anchors.fill: parent
                            onClicked: {
                                monthMenu.open();
                            }
                        }
                    }
                }

                CalendarButton {
                    id: forward
                    buttonWidth: 25
                    buttonHeight: 25
                    color: "transparent"
                    iconSource: Quickshell.iconPath("go-next-symbolic")

                    onButtonClicked: root.set_month(root.month + 1)
                }

                Menu {
                    id: monthMenu
                    Repeater {
                        model: 12
                        MenuItem {
                            text: new Date(2025, index, 1).toLocaleDateString(Qt.locale(), "MMMM")
                            onTriggered: {
                                set_month(index);
                                monthMenu.close();
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            color: "transparent"
            implicitHeight: 5
            Layout.fillWidth: true
        }

        Rectangle {
            color: "#2196F3"
            implicitHeight: 1
            Layout.fillWidth: true
        }

        // Sunday - Saturday
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            spacing: 4

            Repeater {
                model: 7
                Rectangle {
                    // just for spacing
                    width: 40
                    height: 40
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        Layout.fillWidth: true
                        text: new Date(2025, 0, index - 2).toLocaleDateString(Qt.locale(), "ddd").slice(0, 1)
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        color: Config.colors.fontcolor
                    }
                }
            }
        }

        // calendar
        GridLayout {
            id: grid
            columns: 7
            rows: 6
            columnSpacing: 4
            rowSpacing: 4

            Repeater {
                model: 42

                delegate: Rectangle {
                    color: default_color()
                    radius: 20

                    border.width: 1
                    border.color: is_selected() ? "#2196F3" : "transparent"

                    width: 40
                    height: 40

                    Text {
                        anchors.centerIn: parent
                        text: get_day()
                        color: in_current_month() ? Config.colors.fontcolor : "#2196F3"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            cursorShape = Qt.PointingHandCursor;
                            color = "#2196F3";
                        }
                        onExited: {
                            cursorShape = Qt.ArrowCursor;
                            color = default_color();
                        }
                        onClicked: {
                            var _day = get_day();
                            if (!in_current_month()) {
                                if (index < root._start_weekday) {
                                    set_month(month - 1);
                                } else {
                                    set_month(month + 1);
                                }
                            }
                            root.set_day(_day);
                        }
                    }

                    function default_color() {
                        return 'transparent';
                    }

                    function in_current_month() {
                        return index >= root._start_weekday && (index - root._start_weekday) < root.daysInMonth;
                    }

                    function is_selected() {
                        return root.day == get_day() && in_current_month();
                    }

                    function get_day() {
                        var this_day = index - root._start_weekday + 1;
                        if (this_day > root.daysInMonth) {
                            return this_day - root.daysInMonth;
                        } else if (this_day < 1) {
                            return new Date(root.year, root.month, 0).getDate() + this_day;
                        } else {
                            return this_day;
                        }
                    }
                }
            }
        }
    }

    function set_month(month) {
        var days_in = new Date(year, month + 1, 0).getDate();
        var new_day = Math.min(day, days_in);
        selectedDate = new Date(year, month, new_day);
    }

    function set_day(day) {
        day = Math.min(day, daysInMonth);
        selectedDate = new Date(year, month, day);
    }
}
