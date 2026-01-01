//pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
  id: root

    property PwNode node;

    PwObjectTracker { objects: [root.node] }
}
