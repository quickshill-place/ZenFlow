import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell
import "../../colors.js" as Colors

Item {
    id: workie

    Layout.alignment: Qt.AlignBottom
    Layout.preferredHeight: 200
    Column {
        id: column
        spacing: 8
        anchors.fill: parent

        Repeater {
            model: Hyprland.workspaces.values.length  // Show 5 workspace buttons

            Button {
                id: wsButton
                Text {
                    id: textItem
                    text: (index).toString()
                    color: Colors.foreground
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                background: Rectangle {
                    id: bg
                    color: "#55" + Colors.background.slice(1)  // default color
                    radius: 8
                }
                implicitWidth: 32
                implicitHeight: 32

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        Hyprland.dispatch("workspace " + (index));
                    }

                    onEntered: {
                        textItem.font.bold = true;
                        textItem.color = Colors.primary;
                        bg.border.color = Colors.primary;
                        bg.border.width = 1.5;
                    }
                    onExited: {
                        textItem.font.bold = false;
                        textItem.color = Colors.foreground;
                        bg.border.color = "transparent";
                        bg.border.width = 0;
                    }
                }
            }
        }
    }
}
