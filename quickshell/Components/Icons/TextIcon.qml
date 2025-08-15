import Quickshell
import QtQuick
import qs.Settings
import qs.Components.Styled

StyledText {
    text: ""
    font.family: "tabler-icons"
    font.pointSize: 16
    color: Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
}
