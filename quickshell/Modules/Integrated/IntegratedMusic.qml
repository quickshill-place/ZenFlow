import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.Settings
import qs.Services
import qs.Components
import qs.Modules.Integrated.MusicModules

StyledRect {
    id: mediaControl
    width: parent.width + 32
    height: parent.height
    color: "transparent"
    anchors.top: parent.top
    anchors.topMargin: -8
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: albumArtContainer
        width: parent.width * Theme.scale(Screen)
        height: parent.height * Theme.scale(Screen)
        anchors.centerIn: parent

        // Album art image
        ClippingRectangle {
            id: albumArtwork
            width: parent.width * Theme.scale(Screen) - Settings.settings.globalMargin * 2
            height: parent.height * Theme.scale(Screen) - Settings.settings.globalMargin * 2
            anchors.centerIn: parent
            radius: Settings.settings.hasRadius ? (width + height) / 16 : 0

            color: Qt.darker(Theme.surface, 1.1)
            border.color: Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.3)
            border.width: 1
            z: 1

            ScrollingText {}

            Image {
                id: albumArt
                anchors.fill: parent
                anchors.margins: 0
                fillMode: Image.PreserveAspectCrop
                smooth: true
                mipmap: true
                cache: false
                asynchronous: true
                source: MusicManager.trackArtUrl
                visible: true
            }

            // Fallback icon
            TextIcon {
                anchors.centerIn: parent
                text: "\uf00d"
                font.pixelSize: 14 * Theme.scale(Screen)
                visible: !albumArt.visible
                z: 4
            }

            // Play/Pause overlay (only visible on hover)
            Rectangle {
                anchors.fill: parent
                radius: Settings.settings.hasRadius ? (width + height) / 16 : 0
                color: Qt.rgba(0, 0, 0, 0.5)
                opacity: hovering
                z: 2

                Row {
                    width: parent.width / 2.5
                    height: parent.height / 2.5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Settings.settings.globalMargin

                    anchors.horizontalCenter: parent.horizontalCenter
                    TextIcon {
                        id: prev
                        anchors.right: stop.left
                        text: "\uf697"
                        font.pixelSize: 48
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            id: prevButton
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                            onClicked: MusicManager.previous()
                        }
                        Behavior on scale {
                            NumberAnimation {
                                easing.overshoot: 1.1
                                duration: Settings.settings.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                    TextIcon {
                        id: loop
                        anchors.left: stop.right
                        text: "\uf696"
                        font.pixelSize: 48
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on scale {
                            NumberAnimation {
                                easing.overshoot: 1.1
                                duration: Settings.settings.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                        MouseArea {
                            id: loopButton
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                            onClicked: MusicManager.next()
                        }
                    }
                    TextIcon {
                        id: stop
                        anchors.centerIn: parent
                        text: MusicManager.isPlaying ? "\uf690" : "\uf691"
                        font.pixelSize: 64
                        color: "white"
                        MouseArea {
                            id: playButton
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            enabled: MusicManager.canPlay || MusicManager.canPause
                            onClicked: MusicManager.playPause()
                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                        }
                        Behavior on scale {
                            NumberAnimation {
                                easing.overshoot: 1.1
                                duration: Settings.settings.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                    TextIcon {
                        id: next
                        anchors.left: stop.right
                        text: "\uf696"
                        font.pixelSize: 48
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on scale {
                            NumberAnimation {
                                easing.overshoot: 1.1
                                duration: Settings.settings.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                        MouseArea {
                            id: nextButton
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                            onClicked: MusicManager.next()
                        }
                    }
                    TextIcon {
                        id: shuffle
                        anchors.left: next.right
                        text: MusicManager.shuffle ? "\ueb33" : "\uea1c"
                        font.pixelSize: 32
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 16

                        Behavior on scale {
                            NumberAnimation {
                                easing.overshoot: 1.1
                                duration: Settings.settings.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                        MouseArea {
                            id: shuffleButton
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                            onClicked: MusicManager.shuffle()
                        }
                    }
                }
            }
        }
    }
}
