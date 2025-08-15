import QtQuick 2.15
import QtQuick.Shapes 1.15

Rectangle {
    width: 400
    height: 300
    color: "#f0f0f0"

    Shape {
        id: roundedTriangle
        anchors.centerIn: parent
        width: 200
        height: 200

        ShapePath {
            fillColor: "#4CAF50"
            strokeColor: "#2E7D32"
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 100
            startY: 20  // Top point

            PathLine {
                x: 180
                y: 160
            }  // Bottom right
            PathLine {
                x: 20
                y: 160
            }   // Bottom left
            PathLine {
                x: 100
                y: 20
            }   // Back to top
        }
    }

    // Alternative with more pronounced rounding
    Shape {
        anchors.left: roundedTriangle.right
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        width: 200
        height: 200

        ShapePath {
            fillColor: "#FF5722"
            strokeColor: "#D84315"
            strokeWidth: 3
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 100
            startY: 20

            // Using PathArc for smoother curves
            PathLine {
                x: 170
                y: 140
            }
            PathArc {
                x: 30
                y: 140
                radiusX: 20
                radiusY: 20
                useLargeArc: false
            }
            PathLine {
                x: 100
                y: 20
            }
        }
    }
}
