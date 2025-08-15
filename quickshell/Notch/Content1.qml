import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import qs.Modules
import qs.Settings
import qs.Components
import qs.Modules.Integrated
import qs.Notch.NotchModules

StyledRect {
    anchors.fill: parent
    SwipeView {
        id: view

        width: parent.width
        height: 400
        clip: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            id: firstPage
            IntegratedCalendar {}
        }
        Item {
            id: secondPage
            IntegratedMusic {}
        }
        Item {
            id: thirdPage
        }
    }

    Separator {
        anchors.top: view.bottom
        color: Settings.settings.darkMode ? Theme.backgroundTertiary : Theme.textPrimary
    }

    StyledRect {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: Theme.backgroundSecondary

        AppLauncherButton {
            id: appie
        }

        CalendarButton {
            id: calendie
            anchors.left: parent.left
        }

        MenuButton {
            id: mennie
            anchors.left: calendie.right
        }
        BackgroundSwitcherButton {
            id: backie
            anchors.left: mennie.right
        }
    }
}
