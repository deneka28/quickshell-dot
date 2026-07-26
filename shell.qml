//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland

import "components"
import "components/widgets"
import "components/notifications"
import "components/OSD"

ShellRoot {
    id: root
    Scope {
        Bar {}
        DockPanel {
            id: dockPopup
        }
        Notification {}
        OSD {}
    }
    Connections {
        target: Hyprland

        function onKeyboardLayoutChanged(keyboard, layout) {
            OsdService.showLayout(layout);
        }
    }

    // Caps через xkb состояние
    Connections {
        target: Hyprland

        function onCapsLockChanged(enabled) {
            OsdService.showCaps(enabled);
        }
    }
}
