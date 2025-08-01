// Theme.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    function applyOpacity(color, opacity) {
        return color.replace("#", "#" + opacity);
    }

    // FileView to load theme data from JSON file
    FileView {
        id: themeFile
        path: Settings.themeFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: function (error) {
            if (error.toString().includes("No such file") || error === 2) {
                // File doesn't exist, create it with default values
                writeAdapter();
            }
        }
        JsonAdapter {
            id: themeData

            // Backgrounds
            property string backgroundPrimary: "#0C0D11"
            property string backgroundSecondary: "#151720"
            property string backgroundTertiary: "#1D202B"

            // Surfaces & Elevation
            property string surface: "#1A1C26"
            property string surfaceVariant: "#2A2D3A"

            // Text Colors
            property string textPrimary: "#CACEE2"
            property string textSecondary: "#B7BBD0"
            property string textDisabled: "#6B718A"

            // Accent Colors
            property string accentPrimary: "#A8AEFF"
            property string accentSecondary: "#9EA0FF"
            property string accentTertiary: "#8EABFF"

            // Error/Warning
            property string error: "#FF6B81"
            property string warning: "#FFBB66"

            // Highlights & Focus
            property string highlight: "#E3C2FF"
            property string rippleEffect: "#F3DEFF"

            // Additional Theme Properties
            property string onAccent: "#1A1A1A"
            property string outline: "#44485A"

            // Shadows & Overlays
            property string shadow: "#000000"
            property string overlay: "#11121A"

            property string background: "#070704"
            property string foreground: "#FFFFFF"
            property string primary: "#c8cc78"
            property string secondary: "#c9c9a6"

            property string color0: "#000000"
            property string color1: "#ffb595"
            property string color2: "#b6d086"
            property string color3: "#ffb689"
            property string color4: "#b6d086"
            property string color5: "#f4b2e3"
            property string color6: "#84d5c4"
            property string color7: "#82d3e0"

            property string color8: "#82d3e0"
            property string color9: "#ffb597"
            property string color10: "#f5b2e1"
            property string color11: "#f3bd6e"
            property string color12: "#92cef6"
            property string color13: "#f9b1da"
            property string color14: "#94d5a9"
            property string color15: "#82d3e0"
            property string light_beige: "#f4f1de"
            property string blue: "#006fff"
            property string brick_orange: "#e07a5f"
            property string darkblue: "#3d405b"
            property string cyan_green: "#81b29a"
            property string cream: "#f2cc8f"
        }
    }

    // Backgrounds
    property color backgroundPrimary: themeData.backgroundPrimary
    property color backgroundSecondary: themeData.backgroundSecondary
    property color backgroundTertiary: themeData.backgroundTertiary

    // Surfaces & Elevation
    property color surface: themeData.surface
    property color surfaceVariant: themeData.surfaceVariant

    // Text Colors
    property color textPrimary: themeData.textPrimary
    property color textSecondary: themeData.textSecondary
    property color textDisabled: themeData.textDisabled

    // Accent Colors
    property color accentPrimary: themeData.accentPrimary
    property color accentSecondary: themeData.accentSecondary
    property color accentTertiary: themeData.accentTertiary

    // Error/Warning
    property color error: themeData.error
    property color warning: themeData.warning

    // Highlights & Focus
    property color highlight: themeData.highlight
    property color rippleEffect: themeData.rippleEffect

    // Additional Theme Properties
    property color onAccent: themeData.onAccent
    property color outline: themeData.outline

    // Shadows & Overlays
    property color shadow: applyOpacity(themeData.shadow, "B3")
    property color overlay: applyOpacity(themeData.overlay, "66")

    // Font Properties
    property string fontFamily: "Roboto"         // Family for all text

    // Font size multiplier - adjust this in Settings.json to scale all fonts
    property real fontSizeMultiplier: Settings.settings.fontSizeMultiplier || 1.0

    // Base font sizes (multiplied by fontSizeMultiplier)
    property int fontSizeHeader: Math.round(32 * fontSizeMultiplier)     // Headers and titles
    property int fontSizeBody: Math.round(16 * fontSizeMultiplier)       // Body text and general content
    property int fontSizeSmall: Math.round(14 * fontSizeMultiplier)      // Small text like clock, labels
    property int fontSizeCaption: Math.round(12 * fontSizeMultiplier)    // Captions and fine print
}
