import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "root:/colors.js" as Colors
import qs.widgets.styles

Scope {
    id: scopie
    property bool show: false

    PanelWindow {
        id: poppie

        height: 384
        width: 816

        visible: true

        exclusiveZone: 0

        anchors {
            top: true
        }
        StyledRect {
            id: trigger
            width: dashboard.implicitWidth
            height: 16
            color: "transparent"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: scopie.show = true
                onExited: scopie.show = false
            }
        }
        mask: Region {
            Region {
                x: dashboard.x
                y: dashboard.y
                width: dashboard.width
                height: dashboard.height
            }
            Region {
                x: trigger.x
                y: trigger.y
                width: trigger.width
                height: trigger.height
            }
        }
        color: "transparent"
        StyledRect {
            id: dashboard
            RoundCorner {
                corner: RoundCorner.CornerEnum.TopRight
                size: 50
                color: Colors.blue
                x: -size// Match your border color
            }

            RoundCorner {
                corner: RoundCorner.CornerEnum.TopLeft
                size: 50
                x: dashboard.implicitWidth
                color: Colors.blue
            }

            y: scopie.show ? 0 : -implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter

            color: Colors.blue
            implicitWidth: 700 + 16
            implicitHeight: 320 + 16

            radius: 0

            bottomLeftRadius: 16
            bottomRightRadius: 16

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: scopie.show = true
                onExited: scopie.show = false
            }
            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InSine
                }
            }

            StyledRect {
                anchors.centerIn: parent

                color: Colors.foreground
                bottomLeftRadius: 16
                bottomRightRadius: 16

                implicitWidth: parent.width - 32
                implicitHeight: parent.height - 32
                // Left/Rpane
                StyledRect {
                    color: Colors.blue
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        leftMargin: 16
                        topMargin: 16
                        bottomMargin: 16
                    }
                    width: parent.width / 2 - 24  // Account for margins and spacing
                }

                // Right container for the two stacked panes
                StyledRect {
                    color: "transparent"  // Just a container
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                        rightMargin: 16
                        topMargin: 16
                        bottomMargin: 16
                        verticalCenter: parent.verticalCenter
                    }
                    width: parent.width / 2 - 24

                    // Top right pane
                    StyledRect {
                        color: Colors.blue
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }
                        height: parent.height / 2 - 8 // Half height minus gap
                    }

                    // Bottom right pane
                    StyledRect {
                        color: Colors.blue
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }
                        height: parent.height / 2 - 8  // Half height minus gap
                    }
                }
            }
        }
    }
}
