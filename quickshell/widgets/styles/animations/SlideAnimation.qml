import QtQuick
import Quickshell

// Slide-In Animation
ParallelAnimation {
    
    property bool hasSlideIn: false 

    id: slideInAnimation
    NumberAnimation {
        property: "x"
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
    }
    NumberAnimation {
        property: "opacity"
        to: 1
        duration: 300
        easing.type: Easing.OutCubic
    }
    onFinished: {
        hasSlideIn = true
    }
}

// Slide-Out Animation
ParallelAnimation {
    NumberAnimation {
        property: "x"
        to: 420
        duration: 250
        easing.type: Easing.InCubic
    }
    NumberAnimation {
        property: "opacity"
        to: 0
        duration: 250
        easing.type: Easing.InCubic
    }
    }
}
