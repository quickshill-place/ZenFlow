import QtQuick
import QtQuick.Layouts
import qs.Settings

Item {
    id: root
    width: parent.width
    height: 70
    property var tabsModel: []
    property int currentIndex: 0
    signal tabChanged(int index)
    Column {

        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -28
        RowLayout {
            id: tabBar
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Repeater {
                id: repetah
                model: root.tabsModel
                delegate: Rectangle {
                    id: tabWrapper
                    implicitHeight: tab.height
                    implicitWidth: 56
                    color: "transparent"

                    property bool hovered: false

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (currentIndex !== index) {
                                currentIndex = index;
                                tabChanged(index);
                            }
                        }
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                    }

                    ColumnLayout {
                        id: tab
                        spacing: 2
                        anchors.centerIn: parent
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // Icon
                        Text {
                            text: modelData.icon
                            font.family: "tabler-icons"
                            font.pixelSize: 22
                            color: index === root.currentIndex ? Theme.accentTertiary : tabWrapper.hovered ? Theme.accentPrimary : Theme.textSecondary
                            Layout.alignment: Qt.AlignCenter

                            Behavior on color {
                                ColorAnimation {
                                    duration: Settings.settings.animationDuration
                                    easing.overshoot: 0.1
                                    easing.type: Easing.OutBack
                                }
                            }
                        }
                    }
                }
            }
        }
        // Underline for active tab
        Rectangle {
            height: 32
            radius: height / 2
            color: Theme.accentTertiary
            x: repetah.itemAt(root.currentIndex) ? repetah.itemAt(root.currentIndex).x : 0
            implicitWidth: repetah.itemAt(root.currentIndex) ? repetah.itemAt(root.currentIndex).implicitWidth : 56
            opacity: 0.5
            z: -1
            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InQuad
                }
            }
        }
    }
}
