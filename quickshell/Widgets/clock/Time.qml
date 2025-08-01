pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
    id: root

    readonly property string time: {
        // The passed format string matches the default output of
        // the `date` command
        Qt.formatDateTime(clock.date, "hh:mm:ss ");
    }

    readonly property string date: {
        clock.date, "ddd MMM d AP t yy";
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
