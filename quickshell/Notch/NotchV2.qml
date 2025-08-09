import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import qs.Components
import qs.Widgets.workspaces
import qs.Widgets.clock
import qs.Widgets.battery
import qs.Widgets.audio
import qs.Settings
import qs.Components
import qs.Generics
import qs.Modules
import qs.Modules.Integrated

MaskedPanel {
    id: root
    property bool isHovering: false
    property bool expandContent: false
    property real radius: Settings.settings.radius
    property bool hasRadius: Settings.settings.hasRadius

    StyledRect {
        id: rect
        color: Settings.settings.darkMode ? Theme.backgroundPrimary : Theme.textPrimary
        radius: root.hasRadius ? 50 : 0
        width: root.expandContent ? 400 : 48
        height: root.expandContent ? parent.height / 1.5 : 200
        anchors {
            left: parent.left
            leftMargin: Settings.settings.globalMargin
            verticalCenter: parent.verticalCenter
        }

        Behavior on width {
            NumberAnimation {
                duration: Settings.settings.animationDuration
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: Settings.settings.animationDuration
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                root.isHovering = true;
                tri.x = mouseX;
                tri.y = mouseY;
            }
            onExited: {
                root.isHovering = false;
            }
            onPositionChanged: {
                if (root.isHovering) {
                    tri.x = mouseX - 10;
                    tri.y = mouseY - 10;
                }
            }

            onClicked: root.expandContent = true
            onDoubleClicked: root.expandContent = false
        }

        Item {
            id: notchContent
            anchors.fill: parent
            visible: !root.expandContent

            StyledText {
                text: `${Quickshell.env("USER")}@${hostnameCollector.text.trim()}`
                rotation: 270
                anchors.centerIn: parent
            }

            Process {
                id: hostnameProcess
                command: ["hostname"]
                running: true

                stdout: StdioCollector {
                    id: hostnameCollector
                    waitForEnd: true
                }
            }
        }
        SwipeView {
            id: view

            currentIndex: 1
            width: parent.width
            height: 400
            visible: root.expandContent
            clip: true
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            Item {
                id: firstPage
                IntegratedCalendar {}
            }
            Item {
                id: secondPage
                IntegratedMusic {}
            }
            Item {
                id: thirdPage
            }
        }

        StyledRect {
            id: tri
            rotation: 90
            width: 20
            height: 20
            color: "transparent"

            TextIcon {
                text: "\ueb0b"
            }

            antialiasing: true
            scale: root.isHovering ? pulseScale : 0

            property real pulseScale: 1.0

            Timer {
                id: pulseTimer
                interval: 300 // 500ms
                repeat: true
                running: root.isHovering
                onTriggered: {
                    tri.pulseScale = tri.pulseScale === 1.0 ? 1.2 : 1.0;
                }
            }

            Behavior on scale {
                SpringyAnimation {}
            }
            Behavior on pulseScale {
                SpringyAnimation {}
            }
        }
    }
}
