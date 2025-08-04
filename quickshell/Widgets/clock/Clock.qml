import QtQuick
import Quickshell
import "../styles"

Item {
    id: clockie
    z: 101
    implicitHeight: parent.width + 20
    implicitWidth: parent.width

    StyledText {
        text: Time.time
        font.pointSize: 13
        color: Colors.background
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    property bool show: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: clockie.show = true
        onExited: clockie.show = false
    }
}
