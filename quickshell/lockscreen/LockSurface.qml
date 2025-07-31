import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland

Rectangle {
    id: root

    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: colors.window

    Button {
        text: "‎"
        onClicked: context.unlocked()
    }

    Label {
        id: clock
        property var date: new Date()

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }

        // The native font renderer tends to look nicer at large sizes.
        renderType: Text.NativeRendering
        font.pointSize: 80

        // updates the clock every second
        Timer {
            running: true
            repeat: true
            interval: 1000

            onTriggered: clock.date = new Date()
        }

        // updated when the date changes
        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }

    // Uncommenting this will make the password entry invisible except on the active monitor.
    // visible: Window.active

    TextField {
        id: passwordBox
        anchors.leftMargin: 200

        implicitHeight: parent.height
        implicitWidth: parent.width
        cursorVisible: false

        focus: true

        font.pixelSize: 500
        font.family: "Libre Barcode 128"
        enabled: !root.context.unlockInProgress
        inputMethodHints: Qt.ImhSensitiveData

        // Update the text in the context when the text in the box changes.
        onTextChanged: root.context.currentText = this.text

        // Try to unlock when enter is pressed.
        onAccepted: root.context.tryUnlock()

        // Update the text in the box to match the text in the context.
        // This makes sure multiple monitors have the same text.
        Connections {
            target: root.context

            function onCurrentTextChanged() {
                passwordBox.text = root.context.currentText;
            }
        }
    }
}
