import QtQuick
import Quickshell

import "../services"
import "../settings"
Rectangle {
    id: root
    property int innerSpacing: 5

    visible: true

    Item {
        id: notificationList
        anchors.leftMargin: 1
        anchors.topMargin: 1
        anchors.rightMargin: 1

        Repeater {
            id: rep
            model: (!Shell.flags.misc.dndEnabled && Shell.flags.misc.notificationDaemonEnabled) ? NotifServer.popups : []

            NotificationChild {
                id: child

                property var urgencyLow: Quickshell.iconPath("alt-critical-notif-symbolic")
                property var urgencyCritical: Quickshell.iconPath("critical-notif-symbolic")

                width: 300
                x: 40

                y: {
                    var pos = 0;
                    for (let i = 0; i < index; i++) {
                        var prev = rep.itemAt(i);
                        if (prev)
                            pos += prev.height + root.innerSpacing;
                    }
                    return pos - (tracked ? 0 : 20) + 20;
                }
                Component.onCompleted: {
                    if (!modelData.shown)
                        modelData.shown = true;
                    y += tracked ? 0 : 20;
                }
                Behavior on y {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InOutExpo
                    }
                }
                property var getImage: {
                    switch (modelData.urgency) {
                    case 1:
                        console.log("case1:", modelData.urgency);
                        return modelData.image || modelData.appIcon;
                    case 2:
                        console.log("case2:", modelData.urgency);
                        return urgencyCritical;
                    default:
                        return modelData.image || modelData.appIcon;
                    }
                }
                title: modelData.summary
                body: modelData.body
                //image: modelData.image || modelData.appIcon
                image: getImage
                rawNotif: modelData

                tracked: modelData.shown
                urgency: modelData.urgency
                buttons: modelData.actions.map(action => ({
                            label: action.text,
                            onClick: () => {
                                action.invoke();
                            }
                        }))
            }
        }
    }
}
