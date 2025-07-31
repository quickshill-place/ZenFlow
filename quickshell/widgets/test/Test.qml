
// Battery.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell
import "root:/icons/icons.js" as Icons
import QtQuick.Effects
Item {

    id: itm
    property bool show: false

 implicitWidth: parent.width
                    implicitHeight: parent.width
    Text {
        color: "#fff"
        text: "Hi"
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: itm.show = true
        onExited: itm.show = false
    }

    PopUpTest {
    }
}
