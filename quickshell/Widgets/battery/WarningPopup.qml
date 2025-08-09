import Quickshell
import QtQuick

PanelWindow {
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }
    visible: false

    property int lastBatteryLevel: 100

    // Timer to hide the panel after 4 seconds
    Timer {
        id: hideTimer
        interval: 4000 // 4 seconds
        repeat: false
        onTriggered: {
            visible = false;
        }
    }

    // Monitor battery changes
    Connections {
        target: SingBattery
        function onPercentageChanged() {
            var currentLevel = SingBattery.percentage;

            // Check if battery is below 15% and has decreased
            if (currentLevel < 20 && currentLevel < lastBatteryLevel) {
                visible = true;
                hideTimer.restart(); // Reset the 4-second timer
            }

            lastBatteryLevel = currentLevel;
        }
    }

    color: "transparent"

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        radius: 50
        width: 48
        height: 200
        color: "red"
        opacity: 0.8

        Text {
            anchors.centerIn: parent
            text: "LOW BATTERY " + SingBattery.percentage + "%"
            font.pointSize: 16
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            rotation: 270
        }
    }
}
