pragma Singleton

import Quickshell.Services.UPower
import Quickshell
import Quickshell.Widgets
import QtQuick

Singleton {
  id: root
 
  
readonly property real percentage: UPower.displayDevice.percentage * 100
readonly property int timeToFull: UPower.displayDevice.timeToFull
readonly property int timeToEmpty: UPower.displayDevice.timeToEmpty
readonly property var chargeState: UPower.displayDevice.state
readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
}


