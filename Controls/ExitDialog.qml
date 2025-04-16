import QtQuick 2.15

Rectangle {
    id: exitDialog
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    visible: false
    enabled: false
    radius: height / 4
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
            w: 60
            text: "Quit"
            function clickAction() {
                buttonAction(text)
            }
        }
        ButtonWhite {
            w: 60
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
            visible = true
            enabled = true
        }
    }
    function close() {
        visible = false
        enabled = false
    }
}
