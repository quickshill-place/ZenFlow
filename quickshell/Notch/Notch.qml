import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import qs.Widgets.styles
import qs.Widgets.workspaces
import qs.Widgets.clock
import qs.Widgets.battery
import qs.Widgets.audio
import qs.Settings
import qs.Components

PanelWindow {
    id: root
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

    // Scroll indicator overlay
    Rectangle {
        width: 48
        height: parent.height - 32
        radius: e_rect.show ? 16 : 50
        color: "#30ffffff"
        opacity: e_rect.isScrolling && !e_rect.show ? 1 : 0
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter

        Behavior on opacity {
            OpacityAnimator {
                duration: 200
                easing.type: Easing.InQuad
            }
        }
    }

    StyledRect {
        id: e_rect
        radius: e_rect.show ? 16 : 200
        implicitWidth: e_rect.show ? 404 : 48
        implicitHeight: e_rect.show ? 764 : 200
        color: "transparent"
        focus: true

        property real margin: 20
        property bool show: false
        property bool contentExpanded: false
        property bool isScrolling: false
        property int currentIndex: 0

        Keys.onEscapePressed: {
            e_rect.show = false;
        }

        // Custom swipe implementation using Flickable
        Flickable {
            id: flickie
            anchors.fill: parent
            clip: false
            visible: !e_rect.show

            // Enable vertical scrolling through pages
            contentWidth: width
            contentHeight: height * 3 // 3 pages
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            property int currentIndex: 0
            property bool snapping: false

            // Function to snap to a specific page
            function snapToPage(index) {
                snapping = true;
                contentY = index * height;
                currentIndex = index;
                e_rect.currentIndex = index;
                snapping = false;
            }

            // Handle snapping when flicking stops
            onFlickEnded: {
                var targetIndex = Math.round(contentY / height);
                targetIndex = Math.max(0, Math.min(2, targetIndex));

                if (targetIndex !== currentIndex) {
                    snapToPage(targetIndex);
                }
            }

            // Handle snapping when dragging stops
            onMovementEnded: {
                if (!flickingVertically) {
                    var targetIndex = Math.round(contentY / height);
                    targetIndex = Math.max(0, Math.min(2, targetIndex));
                    snapToPage(targetIndex);
                }
            }

            // Smooth transitions
            Behavior on contentY {
                enabled: flickie.snapping
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Column {
                width: parent.width
                spacing: 0

                // Page 1 - Audio
                Item {
                    width: flickie.width
                    height: flickie.height

                    StyledRect {
                        id: page_1
                        anchors.fill: parent
                        color: Theme.backgroundPrimary
                        radius: 50

                        IntegratedAudio {
                            anchors.fill: parent
                        }

                        opacity: e_rect.currentIndex === 0 ? 1 : (flickie.moving ? 1 : 0)

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 200
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                }

                // Page 2 - User Info
                Item {
                    width: flickie.width
                    height: flickie.height

                    StyledRect {
                        id: page_2
                        anchors.fill: parent
                        color: "#fff"
                        radius: 50

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

                        opacity: e_rect.currentIndex === 1 ? 1 : (flickie.moving ? 1 : (flickie.snapping ? 1 : 0))

                        Behavior on opacity {

                            OpacityAnimator {
                                duration: 200
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                }

                // Page 3 - Clock & Battery
                Item {
                    width: flickie.width
                    height: flickie.height

                    StyledRect {
                        id: page_3
                        anchors.fill: parent
                        color: "#fff"
                        radius: 50

                        Clock {
                            id: clockie
                            rotation: 270
                            anchors.centerIn: parent
                        }

                        Battery {
                            rotation: 270
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 32
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        opacity: e_rect.currentIndex === 2 ? 1 : (flickie.moving ? 1 : 0)

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 200
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                }
            }
        }

        // Expanded content (when show is true)
        Rectangle {
            anchors.fill: parent
            color: "#50ffffff"
            radius: 16
            visible: e_rect.show

            Text {
                text: "Expanded Content"
                anchors.centerIn: parent
                color: "#333"
            }
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
            interval: 160
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

        MouseArea {
            id: mousearea
            property bool clickLocked: false
            hoverEnabled: true
            anchors.fill: parent

            onClicked: {
                if (!e_rect.show) {
                    e_rect.show = true;
                    clickLocked = true;
                }
            }

            onDoubleClicked: {
                e_rect.show = false;
                clickLocked = false;
            }
        }
    }
}
