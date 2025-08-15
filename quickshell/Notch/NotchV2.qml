import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import qs.Widgets.workspaces
import qs.Widgets.clock
import qs.Widgets.battery
import qs.Widgets.audio
import qs.Settings
import qs.Components
import qs.Generics
import qs.Modules
import qs.Modules.Integrated

Variants {
    model: Quickshell.screens

    delegate: Component {
        MaskedPanel {
            id: root
            required property var modelData

            // we can then set the window's screen to the injected property
            screen: modelData
            property bool isHovering: false
            property bool expandContent: Settings.settings.expandContent
            property double radius: Settings.settings.radius
            property bool hasRadius: Settings.settings.hasRadius

            StyledRect {
                id: rect
                color: Settings.settings.darkMode ? Theme.backgroundPrimary : Theme.textPrimary
                radius: root.hasRadius ? 50 : 0
                width: root.expandContent ? parent.width / 4.265 : parent.width / 34
                height: root.expandContent ? parent.height / 1.5 : parent.height / 5.12
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
                    /* onEntered: {
                root.isHovering = true;
                tri.x = mouseX;
                tri.y = mouseY;
                tri2.x = mouseX;
                tri2.y = mouseY;
            }
            onExited: {
                root.isHovering = false;
            }
            onPositionChanged: {
                if (root.isHovering) {
                    tri.x = mouseX - 10;
                    tri.y = mouseY - 10;
                    tri2.x = mouseX - 10;
                    tri2.y = mouseY - 10;
                }
            }
            */

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
                    width: parent.width - 32
                    height: parent.height - 32
                    visible: root.expandContent
                    anchors.centerIn: parent
                    clip: true
                    orientation: Qt.Vertical
                    currentIndex: 0
                    Item {
                        id: firstPage
                        Content1 {}
                    }
                    Item {
                        id: secondPage
                        Content2 {}
                    }
                }
            }
        }
    }
}
