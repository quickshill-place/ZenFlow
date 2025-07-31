// Bar.qml
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.widgets.battery
import qs.widgets.clock
import qs.widgets.audio
import qs.widgets.logout
import qs.widgets.border
import "root:/colors.js" as Colors
import qs.widgets.test
import qs.widgets.styles
import qs.widgets.tools
import qs.widgets.systray

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property real margin: 15
            property real base_margin: 20
            property var modelData

            exclusiveZone: 45

            anchors {
                top: true
                bottom: true
                right: true
            }

            color: "#00" + Colors.background.slice(1)
            StyledRect {

                color: "#00" + Colors.background.slice(1)

                implicitWidth: 40
                implicitHeight: parent.height - 32
                anchors.verticalCenter: parent.verticalCenter

                anchors {
                    right: parent.right
                    rightMargin: 10
                }
                Column {
                    id: column
                    anchors.fill: parent
                    spacing: 10
                    // Arch
                    StyledRect {
                        id: archie
                        implicitHeight: parent.width
                        anchors.topMargin: margin
                        implicitWidth: parent.width
                        anchors.top: parent.top
                        anchors.bottom: toolie
                        Text {
                            text: ""
                            // rotation: 270
                            font.pointSize: 15
                            color: Colors.foreground
                            anchors.centerIn: parent
                        }
                    }

                    SystemTray {
                        bar: bar
                        visible: true
                        anchors.top: archie.bottom
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                    }

                    StyledRect {
                        id: toolie
                        anchors {
                            top: systray.bottom
                        }

                        Tools {}
                        implicitWidth: parent.width
                        implicitHeight: parent.width
                    }

                    // Clock
                    StyledRect {
                        id: clockie
                        implicitWidth: parent.width
                        implicitHeight: 100
                        anchors.centerIn: parent
                        Clock {
                            anchors.centerIn: parent
                        }
                    }

                    // Battery
                    StyledRect {
                        id: batterie
                        implicitHeight: parent.width
                        implicitWidth: parent.width
                        anchors.bottom: loggie.top
                        Battery {}
                    }

                    StyledRect {
                        id: loggie
                        implicitWidth: parent.width
                        implicitHeight: parent.width
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: margin

                        property bool show: false
                        property bool toggled: false

                        Logout {
                            id: wlogout
                        }
                        Text {
                            id: textie
                            text: ""
                            anchors.centerIn: parent
                            color: loggie.show ? Colors.foreground : Colors.foreground
                            font.pointSize: 13

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.OutInCubic
                                }
                            }
                        }

                        MouseArea {
                            hoverEnabled: true
                            onEntered: textie.color = Colors.foreground
                            onExited: textie.color = Colors.foreground
                            anchors.fill: parent
                            onClicked: {
                                loggie.show = true;
                                console.log("Logout works");
                            }
                        }
                    }
                }
            }
        }
    }
}
