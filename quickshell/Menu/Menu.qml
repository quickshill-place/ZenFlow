import Quickshell
import QtQuick
import qs.Components
import qs.Settings
import qs.Generics
import qs.Notch

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }
    mask: Region {
        Region {
            x: menu.x
            y: menu.y
            width: menu.width
            height: menu.height
        }
    }

    property bool show: Settings.settings.showMenu
    property bool showContent: false
    visible: showContent
    color: "transparent"

    onShowChanged: {
        if (show === false) {
            // Start the hide timer
            hideContentTimer.start();
        } else {
            showContent = true;
        }
    }
    Timer {
        id: hideContentTimer
        interval: 350 // Adjust this value for the desired delay
        onTriggered: showContent = false
    }
    StyledRect {
        id: menu
        radius: 50
        visible: root.showContent
        anchors.centerIn: parent
        implicitWidth: root.show ? parent.width / 2 : 0
        implicitHeight: root.show ? parent.height / 2 : 0
        Behavior on implicitWidth {
            SpringyAnimation {}
        }
        Behavior on implicitHeight {
            SpringyAnimation {}
        }
        StyledRect {
            id: tabbie
            implicitHeight: 70
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: textie
                property int counter
                text: counter
                font.pointSize: 20

                z: 100
            }
            Tabs {
                id: settingsTabs
                tabsModel: [
                    {
                        icon: "\uf69e"
                    },
                    {
                        icon: "\ufb27"
                    },
                    {
                        icon: "\uf673"
                    }
                ]

                // Update tab when flickable moves
                onCurrentIndexChanged: {
                    flickey.currentIndex = currentIndex;
                }
            }
        }

        StyledRect {
            implicitWidth: parent.width - 32
            implicitHeight: parent.height - tabbie.height
            radius: 50
            anchors.bottom: parent.bottom
            anchors.margins: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Flickable {
                id: flickey
                anchors.fill: parent
                anchors.margins: 20
                clip: true

                // Enable horizontal scrolling for swipe functionality
                contentWidth: parent.width * 3
                contentHeight: parent.height

                // Snap properties
                property int currentIndex: 0
                property real pageWidth: width
                property bool snapping: false

                // Sync with tab selection
                onCurrentIndexChanged: {
                    if (!snapping) {
                        snapToPage(currentIndex);
                    }
                }

                // Function to snap to a specific page
                function snapToPage(index) {
                    snapping = true;
                    contentX = index * pageWidth;
                    settingsTabs.currentIndex = index;
                    snapping = false;
                }

                // Handle snapping when flicking stops
                onFlickEnded: {
                    var targetIndex = calculateTargetIndex();

                    if (targetIndex !== currentIndex) {
                        currentIndex = targetIndex;
                        snapToPage(targetIndex);
                    }
                }

                // Handle snapping when dragging stops (without flicking)
                onMovementEnded: {
                    if (!flickingHorizontally) {
                        var targetIndex = calculateTargetIndex();

                        if (targetIndex !== currentIndex) {
                            currentIndex = targetIndex;
                        }
                        snapToPage(targetIndex);
                    }
                }

                // Calculate target index with custom threshold
                function calculateTargetIndex() {
                    var threshold = 0.05; // Only need to swipe 5% of page width to change
                    var velocityThreshold = 100; // Minimum velocity for quick swipe
                    var currentPage = currentIndex;
                    var position = contentX / pageWidth;

                    // Quick swipe detection - change page with less distance if swiping fast
                    if (Math.abs(horizontalVelocity) > velocityThreshold) {
                        if (horizontalVelocity > 0 && currentPage < 2) {
                            return currentPage + 1; // Swipe left (positive velocity) = next page
                        } else if (horizontalVelocity < 0 && currentPage > 0) {
                            return currentPage - 1; // Swipe right (negative velocity) = previous page
                        }
                    }

                    // Normal threshold-based detection
                    if (position > currentPage + threshold) {
                        return Math.min(currentPage + 1, 2); // Move to next page
                    } else if (position < currentPage - threshold) {
                        return Math.max(currentPage - 1, 0); // Move to previous page
                    } else {
                        return currentPage; // Stay on current page
                    }
                }

                // Enable smooth transitions
                // FadeBehavior on contentX {}
                Behavior on contentX {
                    enabled: flickey.snapping
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InQuad
                    }
                }

                // Disable vertical scrolling
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.HorizontalFlick

                Row {
                    height: parent.height

                    Item {
                        width: flickey.pageWidth
                        height: flickey.height
                        Text {
                            text: "Page 1"
                            anchors.centerIn: parent
                            font.pixelSize: 24
                        }
                    }

                    Item {
                        width: flickey.pageWidth
                        height: flickey.height
                        Text {
                            text: "Page 2"
                            anchors.centerIn: parent
                            font.pixelSize: 24
                        }
                    }

                    Item {
                        width: flickey.pageWidth
                        height: flickey.height
                        Text {
                            text: "Page 3"
                            anchors.centerIn: parent
                            font.pixelSize: 24
                        }
                    }
                }
            }
        }
    }
}
