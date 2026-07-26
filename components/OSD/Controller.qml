// pragma Singleton
//
// import QtQuick
// import QtQuick.Layouts
// import QtQuick.Controls
// import Quickshell
// import Quickshell.Hyprland
//
// QtObject {
//     id: root
//
//     property bool visible: false
//
//     property string icon: ""
//     property string title: ""
//     property int value: 0
//
//     property int timeout: 1500
//
//     signal showRequested
//
//     Timer {
//         id: hideTimer
//
//         interval: root.timeout
//         repeat: false
//
//         onTriggered: root.visible = false
//     }
//
//     function show(icon, title, value) {
//         root.icon = icon;
//         root.title = title;
//         root.value = value;
//
//         root.visible = true;
//
//         showRequested();
//
//         hideTimer.restart();
//     }
// }
