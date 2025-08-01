import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import "root:/colors.js" as Colors

Variants {
    property color buttonColor: "transparent"
    property color buttonHoverColor: "#50" + Colors.primary.slice(1)
    default property list<ToolButtons> buttons

    model: Quickshell.screens
    PanelWindow {
        id: root

        visible: toolie.show

        property var modelData
        screen: modelData

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        contentItem {
            focus: true
            Keys.onPressed: event => {
                if (event.key == Qt.Key_Escape)
                    toolie.show = false;
                else {
                    for (let i = 0; i < buttons.length; i++) {
                        let button = buttons[i];
                        if (event.key == button.keybind)
                            button.exec();
                    }
                }
            }
        }

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        Rectangle {
            color: "#00" + Colors.background.slice(1)
            anchors.fill: parent

            MouseArea {
                id: mous
                anchors.fill: parent
                onClicked: toolie.show = false

                Rectangle {

                    property var size: parent.width / 2
                    color: "#50" + Colors.background.slice(1)
                    border.color: "#50" + Colors.primary.slice(1)
                    border.width: 4

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        leftMargin: 20
                        rightMargin: 20
                    }
                    height: size * 0.5 / 7
                    width: size * 0.7
                    bottomRightRadius: 20
                    bottomLeftRadius: 20
                    property int targetY: -200
                    y: toolie.show ? -4 : targetY

                    Behavior on y {
                        NumberAnimation {
                            id: yAnim
                            duration: 200
                            easing.type: Easing.InOutCubic
                            onFinished: {
                                if (!toolie.show) {
                                    root.visible = false;
                                }
                            }
                        }
                    }
                }
                GridLayout {
                    id: child
                    anchors {

                        horizontalCenter: parent.horizontalCenter
                    }

                    y: toolie.show ? 6 : -200
                    Behavior on y {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }

                    property var size: parent.width / 2
                    height: size * 0.35 / 7
                    width: size * 0.67
                    columns: 6
                    columnSpacing: 20
                    rowSpacing: 20

                    Repeater {
                        model: buttons

                        delegate: Rectangle {

                            required property ToolButtons modelData

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: ma.containsMouse ? buttonHoverColor : buttonColor
                            border.color: Colors.primary
                            border.width: ma.containsMouse ? 4 : 0
                            radius: 20

                            Behavior on border.width {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutCubic
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutCubic
                                }
                            }

                            MouseArea {
                                id: ma
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: modelData.exec()
                            }

                            IconImage {
                                id: icon
                                anchors.centerIn: parent
                                source: Quickshell.iconPath(`/home/zen/zenflakes/config/quickshell/icons/common/${modelData.icon}.svg`)
                                implicitSize: 28
                            }
                        }
                    }
                }
            }
        }
    }
}
