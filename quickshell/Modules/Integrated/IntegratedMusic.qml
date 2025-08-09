import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.Settings
import qs.Services
import qs.Components

StyledRect {
    id: mediaControl
    width: parent.width
    height: parent.height
    color: "transparent"

    StraightSpectrum {
        id: spectrum2
        values: MusicManager.cavaValues
        anchors.centerIn: parent
        limit: 90 * Theme.scale(Screen)
        usableOuter: parent.height / 2
        z: -1
        anchors.bottom: parent.bottom
    }
    RowLayout {
        id: mediaRow
        height: parent.height
        width: parent.width
        spacing: 8

        Item {
            id: albumArtContainer
            width: parent.width * Theme.scale(Screen)
            height: parent.height * Theme.scale(Screen)
            Layout.alignment: Qt.AlignVCenter

            // Album art image
            ClippingRectangle {
                id: albumArtwork
                width: parent.width * Theme.scale(Screen)
                height: parent.height * Theme.scale(Screen)
                anchors.centerIn: parent
                radius: Settings.settings.hasRadius ? Theme.radius : 0
                color: Qt.darker(Theme.surface, 1.1)
                border.color: Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.3)
                border.width: 1
                z: 1

                Image {
                    id: albumArt
                    anchors.fill: parent
                    anchors.margins: 1
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    mipmap: true
                    cache: false
                    asynchronous: true
                    source: MusicManager.trackArtUrl
                    visible: true
                }

                // Fallback icon
                StyledText {
                    anchors.centerIn: parent
                    text: "music_note"
                    font.family: "Material Symbols Outlined"
                    font.pixelSize: 14 * Theme.scale(Screen)
                    visible: !albumArt.visible
                }

                // Play/Pause overlay (only visible on hover)
                Rectangle {
                    anchors.fill: parent
                    radius: Settings.settings.radius
                    color: Qt.rgba(0, 0, 0, 0.5)
                    visible: playButton.containsMouse
                    z: 2

                    TextIcon {
                        anchors.centerIn: parent
                        text: MusicManager.isPlaying ? "\uf690" : "\uf691"
                        font.pixelSize: 16
                        color: "white"
                    }
                }

                MouseArea {
                    id: playButton
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    enabled: MusicManager.canPlay || MusicManager.canPause
                    onClicked: MusicManager.playPause()
                }
            }
        }

        // Track info
        Text {
            text: MusicManager.trackTitle + " - " + MusicManager.trackArtist
            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: 12 * Theme.scale(Screen)
            elide: Text.ElideRight
            Layout.maximumWidth: 300
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
