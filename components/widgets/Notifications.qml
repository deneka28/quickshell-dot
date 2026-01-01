import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../settings"

Rectangle {
  id: root

  width: iconStatus.width
  height: iconStatus.height

  radius: 2

  property bool isActive: Shell.flags.misc.dndEnabled
  readonly property string themestatustext: isActive ? "Active" : "Inactive"
  property string themestatusicon: isActive ? 
                                    Quickshell.iconPath("notification-disabled-symbolic") : 
                                    Quickshell.iconPath("notification-symbolic")

  color: isActive ? "red" : "green"

  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

  function toggleDnd() {
    Shell.setNestedValue("misc.dndEnabled", !isActive)
  }
  Rectangle {
    id: iconBg
    width: 50
    height: 50
    radius: 25
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 10

    color: root.color

    MouseArea {
      anchors.fill: parent
      onClicked: toggleDnd.toggle()
    }
    IconImage {
      id: iconStatus
      anchors.centerIn: parent
      source: root.themestatusicon
      implicitSize: 32
    }
    
  }
    Column {
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: iconBg.right
      anchors.leftMargin: 10

      Text {
        text: "Focus Mode"
        font.pixelSize: 18
      }
      Text {
        text: root.themestatustext
        font.pointSize: 14
      }
    }
    MouseArea {
      anchors.fill: parent
      propagateComposedEvents: true
      onClicked: {
        root.toggleDnd()
      }
    }
}
