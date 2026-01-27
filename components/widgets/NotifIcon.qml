import "../services"
import "../settings"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs

Rectangle {
    id: root

    property bool isActive: Shell.flags.misc.dndEnabled
    readonly property string themestatustext: isActive ? "Active" : "Inactive"
    property string themestatusicon: isActive ? Quickshell.iconPath("notification-disabled-symbolic") : Quickshell.iconPath("notification-symbolic")

    function toggleDnd() {
        Shell.setNestedValue("misc.dndEnabled", !isActive);
    }

    width: iconStatus.width
    height: iconStatus.height
    color: "transparent"
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    Rectangle {
        id: iconBg

        width: iconStatus.width + 3
        height: iconStatus.height + 3
        color: root.color
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            id: mousArea

            anchors.fill: parent
            onClicked: toggleDnd.toggle()
        }

        IconImage {
            id: iconStatus

            anchors.centerIn: parent
            source: root.themestatusicon
            implicitSize: 20
        }

        Rectangle {
            id: point

            implicitWidth: 6
            implicitHeight: 6
            color: Config.colors.red700
            radius: 15
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: NotifServer.history.length > 0 && !root.isActive
        }

    }

    MouseArea {
        id: area

        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: {
            root.toggleDnd();
        }
    }

}
