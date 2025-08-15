import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components

MaskedPanel {
    id: kanbanBoard

    property var todoItems: []
    property var inProgressItems: []
    property var doneItems: []

    // Add sample data
    Component.onCompleted: {
        todoItems = [
            {
                id: 1,
                title: "Plan project structure",
                description: "Define the overall architecture"
            },
            {
                id: 2,
                title: "Design UI mockups",
                description: "Create visual designs for the interface"
            }
        ];
        inProgressItems = [
            {
                id: 3,
                title: "Implement authentication",
                description: "Add user login functionality"
            }
        ];
        doneItems = [
            {
                id: 4,
                title: "Setup development environment",
                description: "Configure tools and dependencies"
            }
        ];
    }

    StyledRect {
        anchors.centerIn: parent

        width: parent.width / 2
        height: parent.height / 2

        visible: false

        // Main content area
        RowLayout {
            id: boardLayout
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            spacing: 20

            // Column component
            Component {
                id: columnComponent

                Rectangle {
                    property string columnTitle: ""
                    property var items: []
                    property string columnColor: "#ecf0f1"

                    Layout.fillHeight: true
                    Layout.preferredWidth: 350
                    color: columnColor
                    radius: 8
                    border.color: "#bdc3c7"
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        // Column header
                        Rectangle {
                            width: parent.width
                            height: 40
                            color: "#34495e"
                            radius: 4

                            Text {
                                text: columnTitle
                                color: "white"
                                font.pointSize: 14
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }

                        // Items container
                        ScrollView {
                            width: parent.width
                            height: parent.height - 60
                            clip: true

                            Column {
                                width: parent.width
                                spacing: 10

                                Repeater {
                                    model: items

                                    // Task card
                                    Rectangle {
                                        width: parent.width - 20
                                        height: taskContent.height + 20
                                        color: "white"
                                        radius: 6
                                        border.color: "#ddd"
                                        border.width: 1

                                        // Drop shadow effect
                                        Rectangle {
                                            anchors.fill: parent
                                            anchors.topMargin: 2
                                            anchors.leftMargin: 2
                                            color: "#e0e0e0"
                                            radius: parent.radius
                                            z: parent.z - 1
                                        }

                                        Column {
                                            id: taskContent
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.margins: 12
                                            spacing: 8

                                            Text {
                                                text: modelData.title
                                                font.pointSize: 12
                                                font.bold: true
                                                color: "#2c3e50"
                                                wrapMode: Text.WordWrap
                                                width: parent.width
                                            }

                                            Text {
                                                text: modelData.description
                                                font.pointSize: 10
                                                color: "#7f8c8d"
                                                wrapMode: Text.WordWrap
                                                width: parent.width
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true

                                            onEntered: parent.color = "#f8f9fa"
                                            onExited: parent.color = "white"
                                            onClicked: {
                                                console.log("Clicked task:", modelData.title);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Todo Column
            Loader {
                sourceComponent: columnComponent
                onLoaded: {
                    item.columnTitle = "To Do";
                    item.items = Qt.binding(function () {
                        return todoItems;
                    });
                    item.columnColor = "#ffebee";
                }
            }

            // In Progress Column
            Loader {
                sourceComponent: columnComponent
                onLoaded: {
                    item.columnTitle = "In Progress";
                    item.items = Qt.binding(function () {
                        return inProgressItems;
                    });
                    item.columnColor = "#fff3e0";
                }
            }

            // Done Column
            Loader {
                sourceComponent: columnComponent
                onLoaded: {
                    item.columnTitle = "Done";
                    item.items = Qt.binding(function () {
                        return doneItems;
                    });
                    item.columnColor = "#e8f5e8";
                }
            }
        }
    }

    // Add task dialog (simplified)
    Dialog {
        id: addTaskDialog
        width: 400
        height: 300
        title: "Add New Task"

        Column {
            anchors.fill: parent
            spacing: 10

            TextField {
                id: taskTitle
                placeholderText: "Task title"
                width: parent.width
            }

            ScrollView {
                width: parent.width
                height: 100

                TextArea {
                    id: taskDescription
                    placeholderText: "Task description"
                    wrapMode: TextArea.Wrap
                }
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            // Add new task logic would go here
            var newTask = {
                id: Date.now(),
                title: taskTitle.text,
                description: taskDescription.text
            };
            todoItems.push(newTask);
            todoItems = todoItems; // Trigger update

            taskTitle.text = "";
            taskDescription.text = "";
        }
    }
}
