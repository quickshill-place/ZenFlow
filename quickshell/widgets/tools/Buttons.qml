import QtQuick
import Quickshell

WindowTools {

    id: windie

    ToolButtons {
        command: "systemctl reboot"
        text: "Reboot"
        icon: "rotate-rectangle"
    }
    ToolButtons {
        command: "hyprctl dispatch exit"
        text: "Tool"
        icon: "logout"
    }

        ToolButtons {
        command: "systemctl poweroff"
        text: "Shutdown"
        icon: "circle-dashed-x"
    }

    ToolButtons {
        command: "systemctl poweroff"
        text: "Shutdown"
        icon: "circle-dashed-x"
    }

    ToolButtons {
        property bool toggle: false
        command: "qs -p /home/zen/zenflakes/config/quickshell/widgets/tools/buttons/screenshot/Geom.qml"
        text: "Suspend"
        icon: getIcon()

        function getIcon() {
            if (toggle) return "player-record"
            if (toggle === false) return "player-record-empty"
        }
    }
    
    ToolButtons {
        text: "scrshot"
        icon: "screenshot"
        property bool show: true
        command: "qs -p /home/zen/zenflakes/config/quickshell/widgets/tools/buttons/screenshot/Geom.qml"
    }

    
}
