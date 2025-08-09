import QtQuick
import QtQuick.Shapes
import qs.Settings

Shape {
    width: 28
    height: 28

    ShapePath {
        strokeWidth: 0
        strokeColor: Settings.settings.isDark ? Theme.textPrimary : Theme.backgroundPrimary

        fillColor: Settings.settings.isDark ? Theme.backgroundPrimary : Theme.textPrimary
        joinStyle: ShapePath.RoundJoin  // Changed from BevelJoin
        capStyle: ShapePath.RoundCap

        startX: 0
        startY: 16

        PathLine {
            x: 16
            y: 16
        }
        PathLine {
            x: 8
            y: 0
        }
        PathLine {
            x: 0
            y: 16
        }
    }
}
