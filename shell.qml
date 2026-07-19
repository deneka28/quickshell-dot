//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import "components"
import "components/widgets"
import "components/notifications"

ShellRoot {
    id: root
    Scope {
        Bar {}
        DockPanel {
            id: dockPopup
        }
        Notification {}
    }
}
