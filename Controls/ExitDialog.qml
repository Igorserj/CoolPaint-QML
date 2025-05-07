import QtQuick 2.15

Rectangle {
    id: exitDialog
    color: style.currentTheme.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    enabled: false
    radius: height / 4
    state: "hidden"
    Behavior on opacity {
        PropertyAnimation {
            target: exitDialog
            property: "opacity"
            duration: 200
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
        background: exitDialog.parent
        z: -1
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
            duration: 100
        }
        PropertyAnimation {
            target: exitDialog
            property: "x"
            to: (window.width / 1.015 - exitDialog.width) / 2
            duration: 100
        }
        PropertyAnimation {
            target: exitDialog
            property: "x"
            to: (window.width - exitDialog.width) / 2
            duration: 100
        }
    }

    StyleSheet {id: style}

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
            acrylicBackground.activate()
            enabled = true
            state = "visible"
        }
    }
    function close() {
        enabled = false
        state = "hidden"
        popUpFunctions.closeNotification()
        acrylicBackground.deactivate()
    }
}
