import QtQuick
import Quickshell
import qs.Settings
import qs.Components
import qs.Modules
import qs.Services

StyledRect {
    id: rect
    width: parent.width
    height: parent.height / 2
    anchors.centerIn: parent
    color: "transparent"
    z: 3
    property real resetPoint: -parent.width

    StyledText {
        id: scrollingText
        text: MusicManager.trackTitle + " - " + MusicManager.trackArtist
        font.family: Theme.fontFamily
        font.pointSize: 16 * Theme.scale(Screen)
        z: 3
        color: Theme.textPrimary
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        // Animation properties
        property real scrollSpeed: 100 // pixels per second
        property real resetPoint: -contentWidth / 1.5 + -parent.width
        property bool shouldScroll: contentWidth > parent.width

        // Only scroll if text is wider than container
        x: shouldScroll ? scrollX : (parent.width - contentWidth) / 2
        property real scrollX: 0

        Timer {
            id: scrollTimer
            interval: 11 // ~60 FPS
            repeat: true
            running: scrollingText.shouldScroll

            onTriggered: {
                // Move text to the left
                scrollingText.scrollX -= scrollingText.scrollSpeed * (interval / 1000.0);

                // Reset position when text has scrolled past reset point
                if (scrollingText.scrollX <= scrollingText.resetPoint) {
                    scrollingText.scrollX = scrollingText.parent.width;
                }
            }
        }

        // Optional: Pause scrolling on hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: scrollTimer.stop()
            onExited: if (scrollingText.shouldScroll)
                scrollTimer.start()
        }
    }
}
