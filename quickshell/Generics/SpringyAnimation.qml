import QtQuick

SpringAnimation {
    spring: 15.0  // Extremely high spring
    damping: 0.5  // Almost critically damped
    epsilon: 1.0  // Large epsilon for early stop
}
