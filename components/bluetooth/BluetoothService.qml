pragma Singleton
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Адаптер и его состояние
    property var adapter: Bluetooth.defaultAdapter
    property var adapterState: adapter?.state ?? BluetoothAdapterState.Disabled
    property bool isEnabled: adapterState === BluetoothAdapterState.Enabled
    property bool isTransitioning: adapterState === BluetoothAdapterState.Enabling || adapterState === BluetoothAdapterState.Disabling
    property bool isBlocked: adapterState === BluetoothAdapterState.Blocked

    // Устройства
    property var knownDevices: adapter?.devices?.values ?? []
    property var pairedDevices: knownDevices.filter(d => d.paired)
    property var scannedDevices: []
    property bool scanning: false

    // Публичные методы
    function startScan() {
        if (scanning)
            return;
        scannedDevices = [];
        scanning = true;
        scanProcess.running = true;
    }

    function stopScan() {
        if (!scanning)
            return;
        btStdin.write("scan off\n");
        btStdin.write("exit\n");
        scanning = false;
    }
    function toggleAdapter() {
        if (!adapter || isTransitioning || isBlocked)
            return;
        adapter.enabled = !adapter.enabled;
    }

    function pairDevice(address) {
        if (pairProcess.running)
            return;
        pairProcess.command = ["bluetoothctl", "pair", address];
        pairProcess.running = true;
    }

    // Сканирование
    // Запускаем сканирование
    Process {
        id: scanProcess
        command: ["bluetoothctl"]
        running: false
        stdinEnabled: true

        stdout: SplitParser {
            onRead: line => {
                console.log("[BT scan raw]:", line);
                const match = line.match(/\[NEW\] Device ([0-9A-F:]{17}) (.+)/i);
                if (match) {
                    const mac = match[1];
                    const name = match[2].trim();
                    const alreadyPaired = root.pairedDevices.some(d => d.address === mac);
                    const alreadyFound = root.scannedDevices.some(d => d.address === mac);
                    if (!alreadyPaired && !alreadyFound) {
                        root.scannedDevices = [...root.scannedDevices,
                            {
                                address: mac,
                                name: name
                            }
                        ];
                    }
                }
            }
        }

        onRunningChanged: {
            if (running) {
                initTimer.start();
            } else {
                root.scanning = false;
            }
        }
    }

    Timer {
        id: initTimer
        interval: 500
        repeat: false
        onTriggered: {
            scanProcess.write("pairable on\n");
            scanProcess.write("scan on\n");
        }
    }

    // Сопряжение
    Process {
        id: pairProcess
        running: false
        onRunningChanged: {
            if (!running)
                running = false;
        }
        stdout: SplitParser {
            onRead: line => console.log("[BT pair]", line)
        }
    }
}
