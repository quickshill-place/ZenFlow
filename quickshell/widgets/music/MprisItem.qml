import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import "colors.js" as Colors
import Quickshell

PanelWindow {
    color: "transparent"
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }
    Rectangle {
        id: rect

        required property MprisPlayer player

        clip: true
        color: Colors.surface
        radius: 20
        width: 500
        height: 500

        Image {
            id: imgDisk

            anchors.horizontalCenter: rect.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            height: this.width
            layer.enabled: true
            layer.smooth: true
            mipmap: true
            rotation: 0
            smooth: true
            source: rect.player?.trackArtUrl
            width: rect.width - 30
            y: 50

            layer.effect: MultiEffect {
                antialiasing: true
                maskEnabled: true
                maskSpreadAtMin: 1.0
                maskThresholdMax: 1.0
                maskThresholdMin: 0.5

                maskSource: Image {
                    layer.smooth: true
                    mipmap: true
                    smooth: true
                    source: "./Image.svg"
                }
            }
            Behavior on rotation {
                NumberAnimation {
                    duration: rotateTimer.interval
                    easing.type: Easing.Linear
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.bezierCurve: Easing.Linear
                }
            }
        }

        MouseArea {
            id: diskMouseArea

            anchors.bottom: rect.bottom
            anchors.left: rect.left
            anchors.right: rect.right

            // wonky but required
            height: rect.height * 0.40
            hoverEnabled: true

            onClicked: mevent => {
                rect.player?.togglePlaying();
            }
            onEntered: {
                imgDisk.scale = 0.8;
            }
            onExited: {
                imgDisk.scale = 1;
            }
        }

        Timer {
            id: rotateTimer

            interval: 500
            repeat: true
            running: rect.player?.isPlaying

            onRunningChanged: {
                // better hack to not wait for interval completion on quick state changes
                imgDisk.rotation += (rotateTimer.running) ? 3 : 0;
            }
            onTriggered: imgDisk.rotation += 3
        }

        Timer {
            id: mprisDotRotateTimer

            interval: 500
            repeat: true
            running: rect.player?.isPlaying
        }

        ColumnLayout {
            anchors.bottom: imgDisk.top
            anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.margins: 10
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 0
            spacing: 0

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 2

                Text {
                    anchors.fill: parent
                    color: Colors.primary
                    elide: Text.ElideRight
                    font.bold: true
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    text: rect.player?.trackTitle
                    verticalAlignment: Text.AlignBottom
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Text {
                    anchors.fill: parent
                    color: Colors.secondary
                    elide: Text.ElideRight
                    font.bold: true
                    font.pointSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    text: rect.player?.trackArtist
                    verticalAlignment: Text.AlignTop
                }
            }
        }

        Item {
            anchors.left: rect.left
            anchors.leftMargin: 20
            anchors.verticalCenter: rect.verticalCenter
            height: 30
            width: 30

            MatIcon {
                id: prevIcon

                anchors.centerIn: parent
                color: Colors.secondary
                font.bold: true
                font.pixelSize: 30
                icon: "arrow_circle_left"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    rect.player?.previous();
                }
                onEntered: prevIcon.fill = 1
                onExited: prevIcon.fill = 0
            }
        }

        Item {
            anchors.right: rect.right
            anchors.rightMargin: 20
            anchors.verticalCenter: rect.verticalCenter
            height: 30
            width: 30

            MatIcon {
                id: nextIcon

                anchors.centerIn: parent
                color: Colors.secondary
                font.bold: true
                font.pixelSize: 30
                icon: "arrow_circle_right"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    rect.player?.next();
                }
                onEntered: nextIcon.fill = 1
                onExited: nextIcon.fill = 0
            }
        }
    }
}
