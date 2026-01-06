//Now only vertical progress is written
import QtQuick
import QtQml

Item {
    id: root

    required property int progWidth
    property int progHeight
    property int bgWidth
    required property int fgWidth
    property int bgHeight
    property int fgHeight
    required property int value
    property int maxValue: progWidth
    property int minValue: 0
    property color bgColor
    property color fgColor
    property real progRadius

    implicitHeight: progHeight
    implicitWidth: progWidth
    // anchors.centerIn: parent

    Rectangle {
        id: bkGround
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: parent.width > 0 ? bgColor : "grey"
        radius: progRadius
    }

    Rectangle {
        id: foreGround
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: root.fgWidth
        implicitHeight: root.fgHeight
        color: root.fgWidth >= 0 ? fgColor : "blue"
        anchors.bottom: bkGround.bottom
        radius: progRadius
    }

    onValueChanged: {
        root.fgHeight = root.value
    }
}
