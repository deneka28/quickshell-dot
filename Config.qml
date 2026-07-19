// Central config file
pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property string username: "alex"
    property string distro: "Arch Linux (btw)"
    property QtObject colors
    // default font
    property font font: Qt.font({
        "family": "Ubuntu"
    })
    // username
    property string name: "alex"
    property string shell: Quickshell.env("SHELL") ?? "fish"
    // user terminal (wezterm), user shell (fish)
    property string terminal: Quickshell.env("TERM") ?? "wezterm"
    property var keyboardLayouts: [
        {
            "code": "us",
            "label": "English (US)",
            "color": "dadada",
            "default": true
        },
        {
            "code": "ru",
            "label": "Russian",
            "color": "dadada",
            "default": false
        }
    ]

    Component.onCompleted: () => {
        console.log("Hello, " + root.name + "!");
    }

    colors: QtObject {
        // surface colors
        property string neutral: "#010C1D"
        property string fontcolor: '#dadada'
        property string widgetcolor: '#2d2e2f'
        property string widgetcolormidle: '#484848'
        property string widgetcolorhard: '#2d2d2d'
        property string controlscolor: '#6a6a6a'
        property string bgcolor: '#6e7a7c7d'
        // main colors
        property string mainColor0: "#111160"
        property string mainColor1: "#0F0679"
        property string mainColor2: "#1911A6"
        property string mainColor3: "#8D1B82"
        property string mainColor4: "#C80E65"
        property string mainColor5: "#FF0044"
        property string mainColor6: "#DB0037"
        // ui colors
        // -- danger
        property string red900: "#DD0039"
        property string red800: "#FF0042"
        property string red700: "#FF225B"
        property string red600: "#FF4575"
        property string red500: "#FF668D"
        // -- warning
        property string yellow900: "#FFA500"
        property string yellow800: "#EBC600"
        property string yellow700: "#FFD700"
        property string yellow600: "#FFEB3B"
        property string yellow500: "#FFEC88"
    }
}
