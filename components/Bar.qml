//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Effects

import qs
import "shared"
import "workspaces"
import "battery"
import "widgets"
import "devices"
import "bluetooth"

Item {
    id: root
    property string color: Config.colors.widgetcolor
    property int size: 34

    WlrLayershell {
        id: barShadow
        implicitHeight: bar.height + 50
        color: "transparent"
        layer: WlrLayer.Bottom
        exclusionMode: ExclusionMode.Ignore
        anchors: bar.anchors

        Rectangle {
            color: barContent.color
            anchors {
                top: parent.top
            }
            height: barContent.height
            width: parent.width + 40

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                // The vertical offset makes the shadow slightly more prominent
                shadowVerticalOffset: 10
                shadowHorizontalOffset: -20
                shadowBlur: 0.99
                blurMultiplier: 0.75
                shadowColor: "#f0000000"
            }
        }
    }

    PanelWindow {
        id: bar
        implicitHeight: root.size
        color: "transparent"
        anchors {
            top: true
            bottom: false
            left: true
            right: true
        }
        margins {
            top: 4
            right: 0
            left: 0
        }
        Rectangle {
            id: barContent
            anchors.fill: parent
            color: root.color
            RowLayout {
                id: leftLayoutRoot
                spacing: 4
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }
                ArchButton {
                    id: archButton
                }
                BarItem {
                    Workspaces {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                BarItem {
                    CurrentWindow {
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
            RowLayout {
                id: centerLayoutRoot
                spacing: 4
                anchors {
                    centerIn: parent
                    verticalCenter: parent.verticalCenter
                }
                BarItem {
                    Clock {}
                }
                BarItem {
                    NotifIcon {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            RowLayout {
                id: rightLayoutRoot
                spacing: 4
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                BarItem {
                    KbLayout {}
                }
                DeviceButton {}
                BarItem {
                    ScreenshotButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 2
                        anchors.leftMargin: 2
                    }
                }
                BarItem {
                    ClipboardButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 2
                        anchors.rightMargin: 2
                    }
                }
                BarItem {
                    SysTray {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                BarItem {
                    BluetoothIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 2
                        anchors.leftMargin: 2
                    }
                }
                VolumeButton {
                    id: volumeButton
                }
                BatteryRadial {}
                DockButton {}
            }
        }
    }
}
