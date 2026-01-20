import QtQuick
import Quickshell.Services.UPower

import "root:/"
import "../shared"

CircleBat {
    id: root
    size: 30
    colorCircle: isLowBatt ? Config.colors.fontcolor : Config.colors.red900
    colorBackground: Config.colors.bgcolor
    showBackground: true
    arcBegin: 0
    arcEnd: 360 * UPower.displayDevice.percentage
    lineWidth: 2
    property int percentageBatt: UPower.displayDevice.percentage * 100
    property int isLowBatt: percentageBatt > 30

    Text {
        font.pointSize: 10
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Config.colors.fontcolor
        text: {
            if (UPower.displayDevice?.state === UPowerDeviceState.Charging)
                return "󱐋";
            else if (UPower.displayDevice?.state === UPowerDeviceState.PendingCharge && !UPower.onBattery)
                return "󰚥";
            else
                return root.percentageBatt;
        }
            visible: text.length
    }
}
