import QtQuick 
import QtQuick.Shapes5

Item {
    width: 200
    height: 200
    
    Shape {
        anchors.fill: parent
        
        ShapePath {
            fillColor: "#9C27B0"
            strokeColor: "#7B1FA2"
            strokeWidth: 8  // Thicker stroke for more visible rounding
            
            // These properties create the rounded corners
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            
            // Triangle coordinates
            startX: width/2; startY: 30          // Top point
            PathLine { x: width - 30; y: height - 30 }  // Bottom right
            PathLine { x: 30; y: height - 30 }          // Bottom left
            PathLine { x: width/2; y: 30 }              // Back to top
        }
    }
}
