pragma ComponentBehavior: Bound

import QtQuick
import qs.Generics

StyledRect {
    id: tri
    rotation: 90
    width: 20
    height: 20
    color: "transparent"

    TextIcon {
        text: "\ueb0b"
    }

    antialiasing: true
    scale: root.isHovering ? pulseScale : 0

    property real pulseScale: 1.0

    Timer {
        id: pulseTimer
        interval: 300 // 500ms
        repeat: true
        running: root.isHovering
        onTriggered: {
            tri.pulseScale = tri.pulseScale === 1.0 ? 1.2 : 1.0;
        }
    }

    Behavior on scale {
        SpringyAnimation {}
    }
    Behavior on pulseScale {
        SpringyAnimation {}
    }
}
