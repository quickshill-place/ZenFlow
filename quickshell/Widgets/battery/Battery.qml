// Battery.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell
import QtQuick.Effects

Item {
    id: batterie
    z: 100
    width: parent.width
    implicitHeight: parent.implicitHeight
    property bool show: false
    property bool charging: SingBattery.isCharging
    property real percentage: SingBattery.percentage
    property variant palette: ["#ef476f", "#f78c6b", "#ffd166", "#83d483", "#06d6a0", "#0cb0a9", "#118ab2", "#073b4c", "#7b2cbf"]
    property color colour

    // Call colorChange when charging or percentage changes
    onChargingChanged: colorChange()
    onPercentageChanged: colorChange()

    Component.onCompleted: colorChange()

    function colorChange() {
        const charging = batterie.charging;
        const percentage = batterie.percentage;
        const palette = batterie.palette;

        if (charging) {
            batterie.colour = palette[8]; // Purple when charging
        } else {
            if (percentage <= 5) {
                batterie.colour = palette[0]; // Red - critical (0-5%)
            } else if (percentage <= 15) {
                batterie.colour = palette[1]; // Orange-red - very low (6-15%)
            } else if (percentage <= 25) {
                batterie.colour = palette[2]; // Yellow - low (16-25%)
            } else if (percentage <= 35) {
                batterie.colour = palette[3]; // LightGreen - medium-low (26-35%)
            } else if (percentage <= 50) {
                batterie.colour = palette[4]; // Green - medium (36-50%)
            } else if (percentage <= 65) {
                batterie.colour = palette[5]; // Teal - good (51-65%)
            } else if (percentage <= 80) {
                batterie.colour = palette[6]; // Blue - very good (66-80%)
            } else if (percentage < 100) {
                batterie.colour = palette[7]; // DarkBlue - excellent (81-99%)
            } else {
                batterie.colour = palette[8]; // Purple - full or charging (100%)
            }
        }
    }

    Item {
        id: batt_icon
        height: batt_body.height + batt_tip.height
        width: batt_body.width
        anchors.centerIn: parent

        Rectangle {
            id: batt_body
            height: 20
            anchors.top: parent.top
            anchors.topMargin: 2
            width: height / 1.3
            color: "transparent"
            border.width: 1
            border.color: batterie.colour
            radius: 4

            Rectangle {
                id: batt_state
                anchors.top: parent.top
                height: (batterie.percentage / 100) * parent.height
                width: parent.width
                color: batterie.colour
                radius: 4
            }
        }

        Rectangle {
            id: batt_tip
            anchors.top: batt_body.bottom
            anchors.topMargin: -0.5
            anchors.horizontalCenter: batt_body.horizontalCenter
            height: 3
            width: 8
            color: batterie.colour
            border.width: 1
            border.color: batterie.colour
            radius: 4
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: batterie.show = true
        onExited: batterie.show = false
        z: 101
    }

    PopUpBattery {}

    WarningPopup {}
}
