pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

import "root:/"
import "../shared"
import "../services"

BarButton {
// anchors.centerIn: parent
    iconSource: Quickshell.iconPath("preferences-desktop-wallpaper-symbolic")
    MouseArea {
        id: area
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
            
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
            // Сменить обои сейчас
                WallpaperService.setRandomWallpaper()
            } else if (mouse.button === Qt.RightButton) {
               // Включить/выключить автосмену
               WallpaperService.toggleAutoChange()
            }
        }
    }
        
    scale: area.containsMouse ? 1.1 : 1.0
        
    Behavior on scale {
        NumberAnimation {
            duration: 150
        }
    }
        
        // Индикатор автосмены
    Rectangle {
        visible: WallpaperService.autoChange
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 2
        anchors.rightMargin: 2
        width: 6
        height: 6
        radius: 3
        color: "#0cc0f2"
    }
}
