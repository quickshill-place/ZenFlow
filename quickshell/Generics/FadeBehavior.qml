import QtQuick 2.15

Behavior {
    id: root
    property Item fadeTarget: targetProperty.object
    SequentialAnimation {
        NumberAnimation {
            target: root.fadeTarget
            property: "opacity"
            to: 0
            easing.type: Easing.InQuad
        }
        PropertyAction {} // actually change the controlled property between the 2 other animations
        NumberAnimation {
            target: root.fadeTarget
            property: "opacity"
            to: 1
            easing.type: Easing.OutQuad
        }
    }
}
