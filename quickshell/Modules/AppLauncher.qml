import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Wayland
import "root:/Services/Fuzzysort.js" as Fuzzysort

PanelWindow {
    id: appLauncherPanel
    implicitWidth: 460
    implicitHeight: 640 + 32
    color: "transparent"
    visible: false
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    screen: (typeof modelData !== 'undefined' ? modelData : null)
    property bool shouldBeVisible: false

    anchors.top: true
    Component.onCompleted: {
        showAt();
    }
    function showAt() {
        visible = true;
        shouldBeVisible = true;
        searchField.forceActiveFocus();
        root.selectedIndex = 0;
        root.appModel = DesktopEntries.applications.values;
        root.updateFilter();
    }

    function hidePanel() {
        shouldBeVisible = false;
        searchField.text = "";
        root.selectedIndex = 0;
    }

    Rectangle {
        id: root
        width: 400
        height: 640
        radius: 16

        color: Colors.blue

        property var appModel: DesktopEntries.applications.values
        property var filteredApps: []
        property int selectedIndex: 0
        property int targetY: (parent.height - height) / 2 + 16
        y: appLauncherPanel.shouldBeVisible ? targetY : -height
        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        scale: appLauncherPanel.shouldBeVisible ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }
        onScaleChanged: {
            if (scale === 0 && !appLauncherPanel.shouldBeVisible) {
                appLauncherPanel.visible = false;
            }
        }
        function isMathExpression(str) {
            return /^[-+*/().0-9\s]+$/.test(str);
        }
        function safeEval(expr) {
            try {
                return Function('return (' + expr + ')')();
            } catch (e) {
                return undefined;
            }
        }
        function updateFilter() {
            var query = searchField.text ? searchField.text.toLowerCase() : "";
            var apps = root.appModel.slice();
            var results = [];
            // Calculator mode: starts with '='
            if (query.startsWith("=")) {
                var expr = searchField.text.slice(1).trim();
                if (expr && isMathExpression(expr)) {
                    var value = safeEval(expr);
                    if (value !== undefined && value !== null && value !== "") {
                        results.push({
                            isCalculator: true,
                            name: `Calculator: ${expr} = ${value}`,
                            result: value,
                            expr: expr,
                            icon: "calculate"
                        });
                    }
                }
            }
            if (!query || query.startsWith("=")) {
                results = results.concat(apps.sort(function (a, b) {
                    return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
                }));
            } else {
                var fuzzyResults = Fuzzysort.go(query, apps, {
                    keys: ["name", "comment", "genericName"]
                });
                results = results.concat(fuzzyResults.map(function (r) {
                    return r.obj;
                }));
            }
            root.filteredApps = results;
            root.selectedIndex = 0;
        }
        function selectNext() {
            if (filteredApps.length > 0)
                selectedIndex = Math.min(selectedIndex + 1, filteredApps.length - 1);
        }
        function selectPrev() {
            if (filteredApps.length > 0)
                selectedIndex = Math.max(selectedIndex - 1, 0);
        }

        function activateSelected() {
            if (filteredApps.length === 0)
                return;

            var modelData = filteredApps[selectedIndex];

            if (modelData.isCalculator) {
                Qt.callLater(function () {
                    Quickshell.clipboardText = String(modelData.result);
                    Quickshell.execDetached(["notify-send", "Calculator Result", `${modelData.expr} = ${modelData.result} (copied to clipboard)`]);
                });
            } else if (modelData.execute) {
                modelData.execute();
            } else {
                var execCmd = modelData.execString || modelData.exec || "";
                if (execCmd) {
                    execCmd = execCmd.replace(/\s?%[fFuUdDnNiCkvm]/g, '');
                    Quickshell.execDetached(["sh", "-c", execCmd.trim()]);
                }
            }

            appLauncherPanel.hidePanel();
            searchField.text = "";
        }

        Component.onCompleted: updateFilter()

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 32
            spacing: 18

            // Search Bar
            Rectangle {
                id: searchBar
                radius: 22
                height: 48
                Layout.fillWidth: true
                border.width: searchField.activeFocus ? 2 : 1

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 10
                    Text {
                        text: "search"
                        font.family: "Material Symbols Outlined"
                        verticalAlignment: Text.AlignVCenter
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: searchField
                        placeholderText: "Search apps..."
                        background: null
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        onTextChanged: root.updateFilter()
                        padding: 0
                        verticalAlignment: TextInput.AlignVCenter
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0
                        font.bold: true

                        Keys.onDownPressed: root.selectNext()
                        Keys.onUpPressed: root.selectPrev()
                        Keys.onEnterPressed: root.activateSelected()
                        Keys.onReturnPressed: root.activateSelected()
                        Keys.onEscapePressed: appLauncherPanel.hidePanel()
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 120
                    }
                }
                Behavior on border.width {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            // App List Card
            Rectangle {
                radius: 20
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                anchors.margins: 0
                property int innerPadding: 16

                Item {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.innerPadding
                    visible: false
                }

                ListView {
                    id: appList
                    anchors.fill: parent
                    anchors.margins: parent.innerPadding
                    spacing: 2
                    model: root.filteredApps
                    currentIndex: root.selectedIndex
                    delegate: Item {
                        id: appDelegate
                        width: appList.width
                        height: 48
                        property bool hovered: mouseArea.containsMouse
                        property bool isSelected: index === root.selectedIndex

                        Rectangle {
                            anchors.fill: parent

                            border.width: hovered || isSelected ? 2 : 0
                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 120
                                }
                            }
                            Behavior on border.width {
                                NumberAnimation {
                                    duration: 120
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10
                            Item {
                                width: 28
                                height: 28
                                property bool iconLoaded: !modelData.isCalculator && iconImg.status === Image.Ready && iconImg.source !== "" && iconImg.status !== Image.Error
                                Image {
                                    id: iconImg
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    cache: false
                                    asynchronous: true
                                    source: modelData.isCalculator ? "qrc:/icons/calculate.svg" : Quickshell.iconPath(modelData.icon, "application-x-executable")
                                    visible: modelData.isCalculator || parent.iconLoaded
                                }
                                Text {
                                    anchors.centerIn: parent
                                    visible: !modelData.isCalculator && !parent.iconLoaded
                                    text: "broken_image"
                                    font.family: "Material Symbols Outlined"
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Text {
                                    text: modelData.name
                                    font.bold: hovered || isSelected
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.isCalculator ? (modelData.expr + " = " + modelData.result) : (modelData.comment || modelData.genericName || "No description available")
                                    font.italic: !(modelData.comment || modelData.genericName)
                                    opacity: (modelData.comment || modelData.genericName) ? 1.0 : 0.6
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.activateSelected();
                            }
                        }
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            opacity: index === appList.count - 1 ? 0 : 0.10
                        }
                    }
                }
            }
        }
    }
}
