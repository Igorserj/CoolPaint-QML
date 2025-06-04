import QtQuick 2.15

Rectangle {
    id: exitDialog
    color: window.style.currentTheme.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    enabled: false
    radius: strictStyle ? 0 : height / 4
    state: "hidden"
    Behavior on opacity {
        PropertyAnimation {
            target: exitDialog
            property: "opacity"
            duration: strictStyle ? 0 : 200
        }
    }
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: exitDialog
                opacity: 1
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: exitDialog
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
            } else if (event.key === Qt.Key_Return) {
                exit()
            }
        }
    }
    Label {
        width: labelArea.width
        height: parent.height / 2
        x: (parent.width - width) / 2
        text: 'Do you wish to quit?'
    }
    Row {
        id: row
        x: (parent.width - width) / 2
        y: parent.height / 2
        spacing: parent.width / 40
        ButtonWhite {
            w: 50
            text: "Quit"
            function clickAction() {
                buttonAction(text)
            }
        }
        ButtonWhite {
            w: 50
            text: "Cancel"
            function clickAction() {
                buttonAction(text)
            }
        }
    }
    SequentialAnimation {
        id: rejectClosing
        PropertyAnimation {
            target: exitDialog
            property: "x"
            to: (window.width * 1.015 - exitDialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
        PropertyAnimation {
            target: exitDialog
            property: "x"
            to: (window.width / 1.015 - exitDialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
        PropertyAnimation {
            target: exitDialog
            property: "x"
            to: (window.width - exitDialog.width) / 2
            duration: strictStyle ? 0 : 100
        }
    }

    function buttonAction(text) {
        if (text === 'Quit') {
            exit()
        } else if (text === 'Cancel') {
            close()
        }
    }

    function exit() {
        Qt.quit()
    }
    function open() {
        if (visible && enabled) rejectClosing.start()
        else {
            disableMainArea()
            dialogArea.focus = true
            acrylicBackground.activate()
            enabled = true
            state = "visible"
        }
    }
    function close() {
        enableMainArea()
        enabled = false
        state = "hidden"
        popUpFunctions.closeNotification()
        acrylicBackground.deactivate()
    }
}
