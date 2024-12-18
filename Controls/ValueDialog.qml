import QtQuick 2.15

Rectangle {
    property double val
    property var updFunc
    width: window.width / 1280 * 300
    height: width / 30 * 30
    color: style.pinkWhite
    visible: false
    enabled: false
    radius: width / 4
    TextEdit {
        id: textEdit
        clip: true
        text: val.toFixed(2)
        anchors.centerIn: parent
        color: style.lightDark
        font.pixelSize: parent.height / 30 * 12
    }
    ButtonWhite {
        w: 50
        anchors.top: parent.top
        anchors.left: parent.right
        text: "Apply"
        function clickAction() {
            updFunc(parseFloat(textEdit.text))
            close()
        }
    }
    ButtonWhite {
        w: 50
        anchors.left: parent.right
        anchors.bottom: parent.bottom
        text: "Close"
        function clickAction() {
            close()
        }
    }
    StyleSheet {id: style}

    function open(value, updateFunc) {
        val = value
        visible = true
        enabled = true
        updFunc = updateFunc
    }
    function close() {
        visible = false
        enabled = false
        val = 0.0
    }
}
