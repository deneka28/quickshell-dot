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

Scope {

    Variants {
        model: Quickshell.screens



        PanelWindow {
            id: root
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 34
            implicitWidth: screen.width

            margins {
                top: 4
                right: 0
                left: 0
            }
            color: "transparent"

            Rectangle {
                id: bar
                implicitHeight: parent.height
                implicitWidth: parent.width

                color: Config.colors.widgetcolor
                // color: "transparent"

                RowLayout {
                    id: leftLayoutRoot

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
                                // centerIn: parent
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                RowLayout {
                    id: centerLayoutRoot

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

                    anchors {
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    BarItem {
                        KbLayout {}
                    }
                    BarItem {
                        SysTray {
                            anchors.verticalCenter: parent.verticalCenter
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
}
