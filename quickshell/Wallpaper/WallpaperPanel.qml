import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import qs.Settings
import qs.Services
import qs.Components

import qs.Components.Styled

PanelWindow {
    id: wallpaperPanelModal

    color: "transparent"
    anchors.top: true
    anchors.right: true
    anchors.left: true
    anchors.bottom: true
    margins.right: 0
    margins.top: 0

    mask: Region {
        width: recty.width
        height: recty.height
        x: recty.x
        y: recty.y
    }

    property var wallpapers: []

    Connections {
        target: WallpaperManager
        function onWallpaperListChanged() {
            wallpapers = WallpaperManager.wallpaperList;
        }
    }

    onVisibleChanged: {
        if (wallpaperPanelModal.visible) {
            wallpapers = WallpaperManager.wallpaperList;
        } else {
            wallpapers = [];
        }
    }

    Rectangle {
        id: recty
        anchors.centerIn: parent
        implicitWidth: parent.width / 2
        implicitHeight: parent.height / 2
        color: Theme.backgroundPrimary
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 0

            // Wallpaper grid area
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.margins: 0
                clip: true
                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    GridView {
                        id: wallpaperGrid

                        anchors.fill: parent
                        cellWidth: Math.max(120, (scrollView.width / 3) - 12)
                        cellHeight: cellWidth * 0.6
                        model: wallpapers
                        cacheBuffer: 32
                        leftMargin: 8
                        rightMargin: 8
                        topMargin: 8
                        bottomMargin: 8
                        delegate: Item {
                            width: wallpaperGrid.cellWidth - 8
                            height: wallpaperGrid.cellHeight - 8
                            StyledClippingRect {
                                id: wallpaperItem
                                anchors.fill: parent
                                anchors.margins: 4
                                color: Qt.darker(Theme.backgroundPrimary, 1.1)
                                border.color: Settings.settings.currentWallpaper === modelData ? Theme.accentPrimary : Theme.outline
                                border.width: Settings.settings.currentWallpaper === modelData ? 3 : 1
                                CachingImages {
                                    id: wallpaperImage
                                    anchors.fill: parent
                                    path: modelData
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                    sourceSize.width: Math.min(width, 150)
                                    sourceSize.height: Math.min(height, 90)
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        WallpaperManager.changeWallpaper(modelData);
                                    }
                                    onEntered: wallpaperItem.border.color = Theme.accentPrimary
                                    onExited: wallpaperItem.border.color = Theme.outline
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
