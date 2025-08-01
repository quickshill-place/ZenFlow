import QtQuick
import Quickshell

Wlogout {
    
    LogoutButton {
        command: "systemctl reboot"
        keybind: Qt.Key_R
        text: "Reboot"
        icon: "rotate-rectangle"
    }
    LogoutButton {
        command: "hyprctl dispatch exit"
        keybind: Qt.Key_E
        text: "Logout"
        icon: "logout"
    }

    LogoutButton {
        command: "systemctl suspend"
        keybind: Qt.Key_U
        text: "Suspend"
        icon: "player-record"
    }


    LogoutButton {
        command: "systemctl poweroff"
        keybind: Qt.Key_K
        text: "Shutdown"
        icon: "circle-dashed-x"
    }

    
}
