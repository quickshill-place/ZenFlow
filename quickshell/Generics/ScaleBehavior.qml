Behavior {
    id: root
    property Item scaleTarget: targetProperty.object
    SequentialAnimation {
        SpringyAnimation {
            target: root.fadeTarget
            property: "scale"
            to: 0
        }
        PropertyAction {} // actually change the controlled property between the 2 other animations
        SpringyAnimation {
            target: root.fadeTarget
            property: "scale"
            to: 1
        }
    }
}
