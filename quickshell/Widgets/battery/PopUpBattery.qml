// PopUpBattery.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.Components

PopupWindow {
    id: poppie
    color: "#BB" + Colors.background.slice(1)
    anchor.item: parent
    anchor.edges: Edges.Bottom | Edges.Right
    implicitWidth: 256
    implicitHeight: 100
    visible: batterie.show
    ColumnLayout {
        width: parent.width
        spacing: 30
        Item {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.leftMargin: 10
            StyledText {
                color: "#fff"
                text: "Percentage: " + (SingBattery.percentage).toFixed(0) + "%"
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pointSize: 13
            }
        }

        Item {

            width: parent.width / 1.2
            height: 20
            Layout.alignment: Qt.AlignHCenter
            StyledText {
                text: "State: " + onBatteryStateChange()
                font.pointSize: 12
                color: "#fff"
                function onBatteryStateChange() {
                    var state = SingBattery.chargeState;

                    if (state === UPowerDeviceState.Charging)
                        return "Charging";
                    if (state === UPowerDeviceState.Discharging)
                        return "Discharging";
                    if (state === UPowerDeviceState.Empty)
                        return "Empty";
                    if (state === UPowerDeviceState.PendingCharge)
                        return "PendingCharge ";
                    if (state === UPowerDeviceState.PendingDischarge)
                        return "PendingDischarge";
                    if (state === UPowerDeviceState.FullyCharged)
                        return "FullyCharged";
                    if (state === UPowerDeviceState.Uknown)
                        return "Huh";
                }
            }
        }
    }
}
