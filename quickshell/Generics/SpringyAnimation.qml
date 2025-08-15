import QtQuick
import qs.Settings

NumberAnimation {
    duration: Settings.settings.animationDuration
    overshoot: 0.1
    easing.type: Easing.OutBack
}
