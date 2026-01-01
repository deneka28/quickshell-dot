import QtQuick
import Quickshell.Wayland
import qs
Rectangle {
    id: root
    implicitHeight: 34
    implicitWidth: 350
    anchors.leftMargin: 4
    color: "transparent"
    Text {
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        text: ToplevelManager.activeToplevel?.activated ? ToplevelManager.activeToplevel.title : ""
        color: palette.active.text
        font.pixelSize: 16
        font.family: Config.font
        anchors.verticalCenter: root.verticalCenter
        width: root.width
        elide: Text.ElideRight
    }
}
