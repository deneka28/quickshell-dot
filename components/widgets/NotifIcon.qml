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
    width: iconStatus.width
    height: iconStatus.height
    color: root.color

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
