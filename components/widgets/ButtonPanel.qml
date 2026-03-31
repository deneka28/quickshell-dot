import QtQuick

Rectangle {
    id: root

    color: "transparent"
    radius: 5
    border.color: "#414141"
    border.width: 2
    implicitHeight: 50
    implicitWidth: parent.width - 30

    Item {
        implicitWidth: parent.width - 20
        implicitHeight: parent.height
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        // border.width: 2
        anchors.centerIn: parent

        WallpaperButton {
            // anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 45
            implicitHeight: 45
        }

    }

}
