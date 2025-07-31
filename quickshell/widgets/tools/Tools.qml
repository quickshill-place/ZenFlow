import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

Item {
    id: toolie
    anchors.centerIn: parent
    implicitWidth: parent.implicitWidth
    implicitHeight: parent.implicitHeight
    IconImage {
        id: icon
        source: Quickshell.iconPath("/home/zen/zenflakes/config/quickshell/icons/common/tool.svg")
        implicitSize: 24
        anchors.centerIn: parent
    }
    property bool show: false


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: toolie.show = !toolie.show
    }

    Buttons {}
}
