pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    enum Type {
        Volume,
        Mute,
        Brightness,
        Layout,
        CapsLock
    }

    property int type: OsdService.Type.Volume
    property real value: 0.0
    property bool boolValue: false
    property string strValue: ""
    property bool visible: false

    function showVolume(v, muted) {
        type = OsdService.Type.Volume;
        value = v;
        boolValue = muted;
        _show();
    }

    function showBrightness(v) {
        type = OsdService.Type.Brightness;
        value = v;
        _show();
    }
    function showLayout(layout) {
        type = OsdService.Type.Layout;
        strValue = layout;
        _show();
    }
    function showCaps(enabled) {
        type = OsdService.Type.CapsLock;
        boolValue = enabled;
        _show();
    }
    function _show() {
        visible = true;
        hideTimer.restart();
    }
    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.visible = false
    }
}
