import "root:/Components/holidays.js" as Holidays
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Components
import qs.Settings
import qs.Modules

StyledRect {
    id: calendarOverlay
    color: "transparent"
    border.color: "transparent"
    border.width: 1
    width: parent.width
    height: 380
    anchors.centerIn: parent
    // Prevent closing when clicking in the panel bg
    MouseArea {
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Month/Year header with navigation
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            IconButton {
                icon: "\uea60"
                onClicked: {
                    let newDate = new Date(calendar.year, calendar.month - 1, 1);
                    calendar.year = newDate.getFullYear();
                    calendar.month = newDate.getMonth();
                }
            }

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: calendar.title
                color: Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
                opacity: 0.7
                font.pixelSize: 13
                font.family: Theme.fontFamily
                font.bold: true
            }

            IconButton {
                icon: "\uea61"
                onClicked: {
                    let newDate = new Date(calendar.year, calendar.month + 1, 1);
                    calendar.year = newDate.getFullYear();
                    calendar.month = newDate.getMonth();
                }
            }
        }

        DayOfWeekRow {
            Layout.fillWidth: true
            spacing: 0
            Layout.leftMargin: 8 // Align with grid
            Layout.rightMargin: 8

            delegate: Text {
                text: shortName
                color: Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary
                opacity: 0.8
                font.pixelSize: 13
                font.family: Theme.fontFamily
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                width: 32
            }
        }

        MonthGrid {
            id: calendar

            property var holidays: []

            // Fetch holidays when calendar is opened or month/year changes
            function updateHolidays() {
                Holidays.getHolidaysForMonth(calendar.year, calendar.month, function (holidays) {
                    calendar.holidays = holidays;
                });
            }

            Layout.fillWidth: true
            spacing: 4
            month: Time.date.getMonth()
            year: Time.date.getFullYear()
            onMonthChanged: updateHolidays()
            onYearChanged: updateHolidays()
            Component.onCompleted: updateHolidays()

            // Optionally, update when the panel becomes visible
            Connections {
                function onVisibleChanged() {
                    if (calendarOverlay.visible) {
                        calendar.month = Time.date.getMonth();
                        calendar.year = Time.date.getFullYear();
                        calendar.updateHolidays();
                    }
                }

                target: calendarOverlay
            }

            delegate: Rectangle {
                property var holidayInfo: calendar.holidays.filter(function (h) {
                    var d = new Date(h.date);
                    return d.getDate() === model.day && d.getMonth() === model.month && d.getFullYear() === model.year;
                })
                property bool isHoliday: holidayInfo.length > 0

                width: 8
                height: 32
                radius: 50

                color: model.today ? Theme.accentPrimary : mouseArea2.containsMouse ? Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundTertiary : "transparent"

                // Holiday dot indicaTtor
                Rectangle {
                    visible: isHoliday
                    width: 4
                    height: 4
                    radius: 4
                    color: Theme.accentTertiary
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 4
                    anchors.rightMargin: 4
                    z: 2
                }

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    color: model.today ? Theme.onAccent : (mouseArea2.containsMouse ? Settings.settings.darkMode ? Theme.backgroundPrimary : Theme.textPrimary : Settings.settings.darkMode ? Theme.textPrimary : Theme.backgroundPrimary)

                    opacity: model.month === calendar.month ? (mouseArea2.containsMouse ? 1 : 0.7) : 0.3
                    font.pixelSize: 13
                    font.family: Theme.fontFamily
                    font.bold: model.today ? true : false
                }
                MouseArea {
                    id: mouseArea2

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        if (isHoliday) {
                            holidayTooltip.text = holidayInfo.map(function (h) {
                                return h.localName + (h.name !== h.localName ? " (" + h.name + ")" : "") + (h.global ? " [Global]" : "");
                            }).join(", ");
                            holidayTooltip.targetItem = parent;
                            holidayTooltip.tooltipVisible = true;
                        }
                    }
                    onExited: holidayTooltip.tooltipVisible = false
                }

                StyledTooltip {
                    id: holidayTooltip

                    text: ""
                    tooltipVisible: false
                    targetItem: null
                    delay: 100
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }
        }
        StyledRect {
            color: Theme.backgroundSecondary
            Layout.fillWidth: true
            Layout.fillHeight: true

            Row {
                anchors.leftMargin: Settings.settings.globalMargin
                anchors.rightMargin: Settings.settings.globalMargin
                anchors.fill: parent
                anchors.centerIn: parent
                IconButton {
                    icon: "\uebba"
                    anchors.verticalCenter: parent.verticalCenter
                }
                IconButton {

                    anchors.verticalCenter: parent.verticalCenter
                }

                IconButton {

                    anchors.verticalCenter: parent.verticalCenter
                }
                IconButton {

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
