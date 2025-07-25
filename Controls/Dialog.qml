import QtQuick 2.15

Rectangle {
    id: dialog
    property string name: ""
    property var options: []
    color: window.style.currentTheme.darkGlass
    width: biggerSide * 240
    height: biggerSide * 80
    enabled: false
    radius: strictStyle ? 0 : height / 4
    state: "hidden"
    Behavior on opacity {
        PropertyAnimation {
            target: dialog
            property: "opacity"
            duration: strictStyle ? 0 : 200
        }
    }
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: dialog
                opacity: 1
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: dialog
                opacity: 0
            }
        }
    ]
    AcrylicBackground {
        id: acrylicBackground
        background: ui
        z: -1
    }
    MouseArea {
        id: dialogArea
        anchors.fill: parent
        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                close()
            }
        }
    }
    Label {
        width: Math.min(parent.width * 0.9, labelArea.width)
        height: parent.height / 2
        x: (parent.width - width) / 2
        text: name
    }
    Row {
        id: row
        x: (parent.width - width) / 2
        y: parent.height / 2
        spacing: parent.width / 40
        Repeater {
            model: options
            ButtonWhite {
                w: 50
                text: modelData.text
                function clickAction() {
                    if (typeof(modelData.func) === "string") {
                        dialog[modelData.func]()
                    } else {
                        close()
                        dialogCallback(modelData.type, modelData.text, modelData.func)
                    }
                }
            }
        }
    }
    SequentialAnimation {
        id: rejectClosing
        PropertyAnimation {
            target: dialog
            property: "x"
            to: (window.width * 1.015 - dialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
        PropertyAnimation {
            target: dialog
            property: "x"
            to: (window.width / 1.015 - dialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
        PropertyAnimation {
            target: dialog
            property: "x"
            to: (window.width - dialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
    }

    function open(header = "", notificationText = "", optionList = []) {
        disableMainArea()
        dialogArea.focus = true
        name = header
        options = optionList
        acrylicBackground.activate()
        enabled = true
        state = "visible"
        if (notificationText !== "") popUpFunctions.openNotification(notificationText, 0)
    }
    function close() {
        enableMainArea()
        enabled = false
        state = "hidden"
        popUpFunctions.closeNotification()
        acrylicBackground.deactivate()
    }
}
