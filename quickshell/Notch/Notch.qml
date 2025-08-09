import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import qs.Components
import qs.Widgets.workspaces
import qs.Widgets.clock
import qs.Widgets.battery
import qs.Widgets.audio
import qs.Settings
import qs.Components
import qs.Generics

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
        implicitWidth: e_rect.show ? 400 : 48
        implicitHeight: e_rect.show ? 764 : 200
        color: "transparent"
        focus: true

        property real margin: 20
        property bool show: false
        property bool contentExpanded: false
        property bool isScrolling: false
        property int currentIndex: 0
        property bool menu_show: false

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
            contentHeight: height * 4 // 3 pages
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            property int currentIndex: 0
            property bool isTransitioning: false
            property real normalizedPosition: contentY / height

            // Update isScrolling status
            onFlickingVerticallyChanged: {
                e_rect.isScrolling = flickingVertically || draggingVertically;
            }
            onDraggingVerticallyChanged: {
                e_rect.isScrolling = flickingVertically || draggingVertically;
            }

            // Function to snap to a specific page
            function snapToPage(index) {
                if (isTransitioning)
                    return;

                isTransitioning = true;
                var targetY = index * height;
                snapAnimation.to = targetY;
                snapAnimation.start();

                currentIndex = index;
                e_rect.currentIndex = index;
            }

            // Smooth snap animation
            NumberAnimation {
                id: snapAnimation
                target: flickie
                property: "contentY"
                duration: 300
                easing.type: Easing.InOutQuad
                onFinished: {
                    flickie.isTransitioning = false;
                }
            }

            // Handle snapping when flicking stops
            onFlickEnded: {
                if (isTransitioning)
                    return;

                var targetIndex = Math.round(contentY / height);
                targetIndex = Math.max(0, Math.min(2, targetIndex));

                if (targetIndex !== currentIndex) {
                    snapToPage(targetIndex);
                }
            }

            // Handle snapping when dragging stops
            onMovementEnded: {
                if (!flickingVertically && !isTransitioning) {
                    var targetIndex = Math.round(contentY / height);
                    targetIndex = Math.max(0, Math.min(2, targetIndex));
                    if (targetIndex !== currentIndex) {
                        snapToPage(targetIndex);
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 24

                // Page 1 - Audio
                Item {
                    width: flickie.width
                    height: flickie.height

                    StyledRect {
                        id: page_1
                        anchors.fill: parent
                        radius: 50

                        IntegratedAudio {
                            anchors.fill: parent
                        }

                        // Simplified opacity calculation
                        opacity: {
                            if (flickie.isTransitioning || flickie.draggingVertically || flickie.flickingVertically) {
                                return 1; // Always visible during transitions
                            }
                            return e_rect.currentIndex === 0 ? 1 : 0;
                        }

                        Behavior on opacity {
                            enabled: !flickie.draggingVertically && !flickie.flickingVertically && !flickie.isTransitioning
                            OpacityAnimator {
                                duration: 150
                                easing.type: Easing.OutQuad
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

                        // Simplified opacity calculation
                        opacity: {
                            if (flickie.isTransitioning || flickie.draggingVertically || flickie.flickingVertically) {
                                return 1; // Always visible during transitions
                            }
                            return e_rect.currentIndex === 1 ? 1 : 0;
                        }

                        Behavior on opacity {
                            enabled: !flickie.draggingVertically && !flickie.flickingVertically && !flickie.isTransitioning
                            OpacityAnimator {
                                duration: 150
                                easing.type: Easing.OutQuad
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

                        // Simplified opacity calculation
                        opacity: {
                            if (flickie.isTransitioning || flickie.draggingVertically || flickie.flickingVertically) {
                                return 1; // Always visible during transitions
                            }
                            return e_rect.currentIndex === 2 ? 1 : 0;
                        }

                        Behavior on opacity {
                            enabled: !flickie.draggingVertically && !flickie.flickingVertically && !flickie.isTransitioning
                            OpacityAnimator {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                Item {
                    width: flickie.width
                    height: flickie.height

                    StyledRect {
                        id: page_4
                        anchors.fill: parent
                        radius: 50

                        // Simplified opacity calculation
                        opacity: {
                            if (flickie.isTransitioning || flickie.draggingVertically || flickie.flickingVertically) {
                                return 1; // Always visible during transitions
                            }
                            return e_rect.currentIndex === 2 ? 1 : 0;
                        }

                        Behavior on opacity {
                            enabled: !flickie.draggingVertically && !flickie.flickingVertically && !flickie.isTransitioning
                            OpacityAnimator {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }
        }

        // Expanded content (when show is true)
        StyledRect {
            anchors.fill: parent
            radius: 16
            opacity: e_rect.show ? 1 : 0
            z: 100

            StyledRect {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 16
                height: 32
                width: height
                color: "transparent"
                visible: e_rect.contentExpanded
                Text {
                    font.family: "tabler-icons"
                    text: "\uf69e"
                    font.pointSize: parent.height / 2
                    color: "#fff"
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Settings.settings.showMenu = !Settings.settings.showMenu;
                        console.log("yup");
                    }
                }
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
            interval: 150
            onTriggered: e_rect.contentExpanded = true
        }

        Behavior on implicitWidth {
            SpringyAnimation {}
        }
        Behavior on implicitHeight {
            SpringyAnimation {}
        }
        Behavior on radius {
            SpringyAnimation {}
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
