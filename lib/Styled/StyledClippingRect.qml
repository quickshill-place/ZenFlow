import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Settings

ClippingRectangle {
    radius: Settings.settings.hasRadius ? 50 : 0
    width: 100
    height: 100
    color: Settings.settings.darkMode ? Theme.backgroundPrimary : Theme.textPrimary
}
