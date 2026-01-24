import QtQuick

import "root:/"

Rectangle {
  id: root
  property bool hovered: mouseArea.containsMouse
  implicitHeight: 30
  implicitWidth: label.contentWidth + 8
  color: Config.colors.controlscolor
  opacity: root.hovered ? 0.7 : 1.0
  radius: 6
  border.width: 1
  border.color: "#454545"
  
  property string text
  property real fontPixelSize
  property real fontPointSize
  property color fontColor
  signal clicked

  Text {
    id: label
    font.pointSize: root.fontPointSize
    font.pixelSize: root.fontPixelSize
    color: root.fontColor
    text: root.text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.centerIn: parent
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: root.enabled

    onClicked: {
      root.clicked()
    }
  }
}
