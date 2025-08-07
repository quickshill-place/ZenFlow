import QtQuick
import QtQuick.Layouts
import qs.Settings

Item {
    id: root
    property var tabsModel: []
    property int currentIndex: 0
    signal tabChanged(int index)

    Text {
        id: textw
        text: root.currentIndex
        z: 100
    }

    RowLayout {
        id: tabBar
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16

        Repeater {
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
                        color: index === root.currentIndex ? Theme : tabWrapper.hovered ? Theme.accentPrimary : Theme.textSecondary
                        Layout.alignment: Qt.AlignCenter
                    }
                }
            }
        }
    }
    // Underline for active tab
    Rectangle {
        width: 32
        height: 32
        radius: 8
        color: Theme.accentTertiary
        y: -4
        x: (root.currentIndex - 16) * 6
        opacity: 0.5
        z: -1
    }
}
