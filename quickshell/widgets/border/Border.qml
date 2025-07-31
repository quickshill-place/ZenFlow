import Quickshell
import QtQuick
import QtQuick.Effects
import "root:/colors.js" as Colors

PanelWindow {

    property int leftMargin: bar.implicitWidth  // store at creation
    property int rightMargin: right_bar.implicitWidth
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    mask: Region {}

    color: "transparent"

    Item {
        anchors.fill: parent

        Rectangle {
            id: rect
            anchors.fill: parent
            color: "#80" + Colors.background.slice(1)
            visible: false
        }

        Item {
            id: maskw
            anchors.fill: parent
            layer.enabled: true
            visible: false

            Rectangle {
                anchors.fill: parent
                anchors.rightMargin: rightMargin
                anchors.leftMargin: leftMargin
                radius: 16
            }
        }

        MultiEffect {
            anchors.fill: parent
            maskEnabled: true
            maskInverted: true
            maskSource: maskw
            source: rect
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }
}
