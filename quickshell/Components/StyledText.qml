import qs.Settings
import QtQuick
import QtQuick.Layouts

Text {
    verticalAlignment: Text.AlignVCenter
    font {
        family: "ZedMono Nerd Font"
        pointSize: 12
    }
    color: Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
}
