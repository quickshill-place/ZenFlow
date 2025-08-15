import qs.Settings
import QtQuick
import QtQuick.Layouts

Text {
    verticalAlignment: Text.AlignVCenter
    font {
        family: Theme.fontFamily
        pointSize: 12
    }
    color: Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
}
