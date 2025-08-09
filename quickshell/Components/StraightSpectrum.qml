import QtQuick
import qs.Components
import qs.Settings
import qs.Services

Item {
    id: root

    // Properties
    property int limit: 48 * Theme.scale(Screen)
    property int strokeWidth: 0 * Theme.scale(Screen)
    property var values: []
    property int usableOuter: 48
    property color fillColor: Settings.settings.isDark ? (MusicManager.isPlaying ? Theme.textPrimary : Theme.backgroundPrimary) : (MusicManager.isPlaying ? Theme.backgroundPrimary : Theme.textPrimary)// Add default color
    property int innerRadius: 10 // Add default inner radius
    property int barWidth: 4 * Theme.scale(Screen)
    property int barSpacing: 0 * Theme.scale(Screen)
    property int animationDuration: 120

    // Calculate total width based on bars and spacing
    width: (root.values.length * (barWidth + barSpacing)) - barSpacing
    height: 380

    onLimitChanged: {
        usableOuter = Settings.settings.visualizerType === "fire" ? limit * 0.9 : limit;
    }
    Repeater {
        model: root.values.length

        Rectangle {
            id: bar
            property real value: root.values[index] || 0

            width: root.barWidth
            height: Math.max(2, value * (root.usableOuter - root.innerRadius))
            color: root.fillColor
            antialiasing: true

            // Position bars horizontally with proper spacing
            x: index * (root.barWidth + root.barSpacing)

            // Anchor bars to bottom for upward growth
            anchors.top: parent.top

            // Smooth animation for height changes
            Behavior on height {
                SmoothedAnimation {
                    duration: root.animationDuration
                    velocity: -1 // Smooth velocity-based animation
                }
            }
        }
    }
}
