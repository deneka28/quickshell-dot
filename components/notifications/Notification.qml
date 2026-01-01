import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../services"
import "../settings"

Scope {
    id: root

    property int innerSpacing: 10

    PanelWindow {
        id: window
        implicitWidth: 540
        visible: true
        anchors {
            top: true
            bottom: true
        }
        color: "transparent"

        // WlrLayershell.layer: WlrLayer.Overlay
        // WlrLayershell.exclusionMode: ExclusionMode.Normal

        mask: Region {
            width: window.width
            height: {
                var total = 0;
                for (let i = 0; i < rep.count; i++) {
                    var child = rep.itemAt(i);
                    if (child) {
                        total += child.height + (i < rep.count - 1 ? root.innerSpacing : 0);
                    }
                }
                return total;
            }
        }
        Item {
            id: notificationList
            anchors.leftMargin: 20
            anchors.topMargin: 6
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id: bgRectangle

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: 1
                    shadowColor: "#000000"
                    shadowBlur: 1
                    shadowScale: 1
                }
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.right: parent.right
                height: window.mask.height > 0 ? window.mask.height + 40 : 0
                color: "transparent"
                radius: 10
                Behavior on height {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutExpo
                    }
                }
            }

            Repeater {
                id: rep
                model: (!Shell.flags.misc.dndEnabled && Shell.flags.misc.notificationDaemonEnabled) ? NotifServer.popups : []

                NotificationChild {
                    id: child
                    property var urgencyLow: Quickshell.iconPath("alt-critical-notif-symbolic")
                    property var urgencyCritical: Quickshell.iconPath("critical-notif-symbolic")
                    width: bgRectangle.width - 40
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
                    // image: modelData.image || modelData.appIcon
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
}
