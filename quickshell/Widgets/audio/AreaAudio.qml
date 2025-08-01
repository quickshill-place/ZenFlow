import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell
import QtQuick.Effects

PanelWindow { 
  id: poppie
  
  implicitWidth: 10
  implicitHeight: 300

  anchors {
    right: true
  }

  property bool showosd: true

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: {
      poppie.showosd = true
      console.log("ented")
    }
    onExited: poppie.showosd = false 


  }
   
}
