import Quickshell
import QtQuick
import QtQuick.Controls
import qs.widgets.styles
import "../colors.js" as Colors
import qs.widgets.clock
import qs.widgets.battery
import QtQuick.Shapes

PanelWindow {
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"
    mask: Region {
        Region {
            x: e_rect.x
            y: e_rect.y
            width: e_rect.width
            height: e_rect.height
        }
    }

    StyledRect {
        id: e_rect
        radius: e_rect.show ? 16 : 200
        implicitWidth: e_rect.show ? 404 : 48
        implicitHeight: e_rect.show ? 764 : 200
        color: Colors.foreground
        focus: true  // Required to receive keyboard input

        property bool show: false
        property bool contentExpanded: false

        Keys.onEscapePressed: {
            e_rect.show = false;
        }

        Clock {
            id: clockie
            rotation: 270
            visible: e_rect.show ? false : true
            anchors.centerIn: parent
        }

        Battery {
            rotation: 270
            visible: e_rect.show ? false : true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -e_rect.implicitHeight / 2 + 30
        }
        onShowChanged: {
            if (show) {
                contentExpandTimer.start();
            } else {
                contentExpanded = false;
            }
        }

        Timer {
            id: contentExpandTimer
            interval: 160  // Slightly after main animation (200ms)
            onTriggered: e_rect.contentExpanded = true
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on radius {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 16
        }

        // Fix: MouseArea that properly tracks the expanding rectangle
        MouseArea {
            id: mousearea
            property bool clickLocked: false
            hoverEnabled: true
            anchors.fill: parent

            onClicked: {
                e_rect.show = true;
                clickLocked = true;
            }
            onDoubleClicked: {
                e_rect.show = false;
                clickLocked = false;
            }
        }
    }
}
