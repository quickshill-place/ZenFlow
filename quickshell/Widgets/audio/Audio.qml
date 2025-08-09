import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Track volume changes
    Connections {
        target: Pipewire.defaultAudioSink?.audio
        function onVolumeChanged() {
            root.show = true;
            hideTimer.restart();
        }
    }

    // Track mute state changes
    Connections {
        target: Pipewire.defaultAudioSink?.audio
        function onMutedChanged() {
            root.show = true;
            hideTimer.restart();
        }
    }

    property bool show: false
    // Use Pipewire API consistently for mute state
    property bool isMuted: Pipewire.defaultAudioSink?.audio.muted ?? false

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.show = false
    }

    LazyLoader {
        active: root.show

        PanelWindow {
            id: volumeWindow
            anchors.left: true
            margins.left: 21
            implicitWidth: 48
            implicitHeight: 196
            color: "transparent"
            exclusiveZone: 0
            mask: Region {}
            Rectangle {
                anchors.fill: parent
                color: "#ff" + Colors.foreground.slice(1)
                radius: 255
                // Animate window appearance/disappearance
                anchors.rightMargin: 9.8
                opacity: root.show ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                // Scale animation for entrance effect
                scale: root.show ? 1.0 : 0.8

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }

                ColumnLayout {

                    anchors {
                        fill: parent
                        bottomMargin: 15
                        topMargin: 15
                    }

                    Text {
                        id: icon

                        font.family: "tabler-icons"
                        font.pointSize: 16

                        text: updateIcon()
                        Layout.alignment: Qt.AlignHCenter

                        function updateIcon() {
                            var volume = Pipewire.defaultAudioSink?.audio.volume ?? 0;
                            var muted = Pipewire.defaultAudioSink?.audio.muted ?? false;

                            // Check mute state first
                            if (muted) {
                                return "\ueb50";
                            }

                            // Then check volume levels
                            if (volume > 0.9) {
                                return "\ueb51";
                            } else if (volume > 0.5) {
                                return "\ueb51";
                            } else if (volume > 0.3) {
                                return "\ueb4f";
                            } else if (volume >= 0.025) {
                                return "\ueb4f";
                            }
                        }

                        // Update icon on volume change
                        Connections {
                            target: Pipewire.defaultAudioSink?.audio
                            function onVolumeChanged() {
                                icon.text = icon.updateIcon();
                            }
                        }

                        // Update icon on mute state change
                        Connections {
                            target: Pipewire.defaultAudioSink?.audio
                            function onMutedChanged() {
                                icon.text = icon.updateIcon();
                            }
                        }

                        // Icon pulse animation when volume changes
                        scale: iconPulse.running ? 1.2 : 1.0

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }

                        // Trigger pulse animation on volume or mute change
                        Connections {
                            target: Pipewire.defaultAudioSink?.audio
                            function onVolumeChanged() {
                                iconPulse.restart();
                            }
                            function onMutedChanged() {
                                iconPulse.restart();
                            }
                        }

                        Timer {
                            id: iconPulse
                            interval: 150
                        }
                    }

                    // Spacer item
                    Item {
                        Layout.preferredHeight: 3
                    }

                    Rectangle {
                        id: volumeBackground
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 10
                        radius: 20
                        color: "#50" + Colors.blue.slice(1)

                        // Animate background color on volume change
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        Rectangle {
                            id: volumeLevel
                            anchors {
                                bottom: parent.bottom
                                left: parent.left
                                right: parent.right
                            }

                            // Show volume level or hide if muted
                            height: {
                                var volume = Pipewire.defaultAudioSink?.audio.volume ?? 0;
                                var muted = Pipewire.defaultAudioSink?.audio.muted ?? false;
                                if (muted) {
                                    return 0; // No volume bar when muted
                                }
                                if (volume >= 1) {
                                    volume = 1;
                                }
                                return parent.height * volume;
                            }

                            Behavior on height {
                                NumberAnimation {
                                    duration: 400
                                    easing.type: Easing.OutCubic
                                }
                            }

                            radius: parent.radius
                            color: "#ffffff"

                            // Color animation based on volume level
                            Behavior on color {
                                ColorAnimation {
                                    duration: 300
                                }
                            }

                            // Change color based on volume level
                            Component.onCompleted: updateColor()

                            Connections {
                                target: Pipewire.defaultAudioSink?.audio
                                function onVolumeChanged() {
                                    volumeLevel.updateColor();
                                    highlightAnimation.restart();
                                }
                                function onMutedChanged() {
                                    volumeLevel.updateColor();
                                    highlightAnimation.restart();
                                }
                            }

                            function updateColor() {
                                var volume = Pipewire.defaultAudioSink?.audio.volume ?? 0;
                                var muted = Pipewire.defaultAudioSink?.audio.muted ?? false;

                                if (muted) {
                                    color = "#666666"; // Gray when muted
                                } else if (volume > 0.9) {
                                    color = "#ff4444"; // Red for high volume
                                } else if (volume > 0.7) {
                                    color = "#ff8f00";
                                } else if (volume > 0.5) {
                                    color = Colors.color11;
                                } else if (volume > 0.3) {
                                    color = Colors.color2;
                                } else {
                                    color = Colors.foreground; // White for low volume
                                }
                            }

                            // Highlight animation
                            SequentialAnimation {
                                id: highlightAnimation

                                NumberAnimation {
                                    target: volumeLevel
                                    property: "opacity"
                                    to: 0.7
                                    duration: 100
                                }

                                NumberAnimation {
                                    target: volumeLevel
                                    property: "opacity"
                                    to: 1.0
                                    duration: 200
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
