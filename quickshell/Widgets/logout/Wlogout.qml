import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import "root:/colors.js" as Colors

Variants {
    id: root
    property bool isClosed: true
    property color buttonColor: Colors.background
    property color buttonHoverColor: "#50" + Colors.primary.slice(1)
    default property list<LogoutButton> buttons

    model: Quickshell.screens
    PanelWindow {
        id: logout

        visible: loggie.show

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
                    loggie.show = false;
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
                onClicked: {
                    loggie.show = false;
                    isClosed = false;
                }

                Rectangle {

                    color: "#50" + Colors.background.slice(1)
                    border.color: "#50" + Colors.primary.slice(1)
                    border.width: 4

                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                        leftMargin: 20
                        rightMargin: 20
                        bottomMargin: -4
                    }
                    height: child.height * 1.34
                    width: child.width * 1.05
                    topRightRadius: 20
                    topLeftRadius: 20
                }
                GridLayout {
                    id: child
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }

                    property var size: parent.width / 2

                    width: size
                    height: size / 7
                    columns: 6
                    columnSpacing: 20
                    rowSpacing: 20

                    Repeater {
                        model: buttons

                        delegate: Rectangle {

                            required property LogoutButton modelData

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: ma.containsMouse ? buttonHoverColor : buttonColor
                            border.color: Colors.primary
                            border.width: ma.containsMouse ? 4 : 0

                            radius: 20

                            Behavior on border.width {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.OutCubic
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
                                source: Quickshell.iconPath(`/home/zen/zenflakes/config/quickshell/icons/logout/${modelData.icon}.svg`)
                                implicitSize: 40
                            }
                        }
                    }
                }
            }
        }
    }
}
