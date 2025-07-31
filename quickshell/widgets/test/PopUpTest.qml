// PopUpBattery.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Layouts
import Quickshell.Services.UPower
import "root:/colors.js" as Colors
import "root:/widgets/styles"
PopupWindow {
    id: poppie
    color: "#BB" + Colors.background.slice(1)
    anchor.item: parent
    anchor.edges: Edges.Bottom | Edges.Right 
    implicitWidth: 256
    implicitHeight: 100 
    visible: itm.show
   
 

}

