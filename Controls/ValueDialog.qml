import QtQuick 2.15

Rectangle {
    property double val
    property var updFunc
    property string text: ""
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    visible: false
    enabled: false
    radius: height / 4
    Label {
        width: valueRect.width - row.width - row.spacing
        x: parent.width * 0.05
        y: (valueRect.y - height) / 2
        text: parent.text
    }
    Rectangle {
        id: valueRect
        width: window.width / 1280 * 220
        height: window.width / 1280 * 30
        x: parent.width * 0.05
        y: parent.height - height - parent.radius / 3
        color: style.pinkWhite
        radius: width / 4
        TextEdit {
            id: textEdit
            clip: true
            text: val.toFixed(2)
            font.family: "Helvetica"
            font.bold: true
            anchors.centerIn: parent
            color: style.lightDark
            font.pixelSize: parent.height / 25 * 12
        }
    }
    Row {
        id: row
        x: parent.width * 0.95 - width
        y: (valueRect.y - height) / 2
        spacing: parent.width / 40
        ButtonWhite {
            w: 40
            text: "Apply"
            function clickAction() {
                updFunc(parseFloat(textEdit.text))
                close()
            }
        }
        ButtonWhite {
            w: 40
            text: "Close"
            function clickAction() {
                close()
            }
        }
    }
    StyleSheet {id: style}
    function open(value, name, updateFunc) {
        canva.disableManipulator()
        val = value
        text = name
        visible = true
        enabled = true
        updFunc = updateFunc
    }
    function close() {
        visible = false
        enabled = false
        val = 0.0
        updFunc = undefined
    }
}
