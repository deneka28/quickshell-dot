import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../settings"
import "../services"
import qs

Rectangle {
  id: root

  width: iconStatus.width
  height: iconStatus.height

  property bool isActive: Shell.flags.misc.dndEnabled
  readonly property string themestatustext: isActive ? "Active" : "Inactive"
  property string themestatusicon: isActive ? 
                                    Quickshell.iconPath("notification-disabled-symbolic") : 
                                    Quickshell.iconPath("notification-symbolic")

  color: "transparent"
  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

  function toggleDnd() {
    Shell.setNestedValue("misc.dndEnabled", !isActive)
  }
  Rectangle {
    id: iconBg
    width: iconStatus.width + 8 
    height: iconStatus.height + 8
    color: root.color
    // border.width: 1
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
    Text {
        visible: NotifServer.history.length > 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: NotifServer.history.length
        color: Config.colors.red900
        font.pixelSize: 10
        font.family: "Ubuntu"
    }
    
  }
  MouseArea {
    id: area
      anchors.fill: parent
      propagateComposedEvents: true
      onClicked: {
        root.toggleDnd()
      }
    }
}
