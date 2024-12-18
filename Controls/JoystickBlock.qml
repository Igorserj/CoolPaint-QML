import QtQuick 2.15

Rectangle {
    id: block
    property string text: ""
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 160
    radius: height / 6
    Text {
        id: label
        text: parent.text
        height: window.width / 1280 * 30
        width: parent.width * 0.9
        font.family: "Helvetica"
        font.bold: true
        color: style.pinkWhiteAccent
        font.pixelSize: parent.height / 160 * 12
        x: parent.radius / 3
        verticalAlignment: Text.AlignVCenter
    }
    Joystick {
        id: joystick
        x: parent.width * 0.05
        y: parent.height - height - parent.radius / 3
    }
    Column {
        x: parent.width * 0.95 - width
        y: 30
        Repeater {
            model: 2
            delegate: Row {
                ButtonWhite {
                    w: 40
                    text: index === 0 ? val1.toFixed(2) : val2.toFixed(2)
                    function clickAction() {
                        if (index === 0)
                            valueDialog.open(val1, updateVal1)
                        else
                            valueDialog.open(val2, updateVal2)
                    }
                }
                ButtonWhite {
                    id: resetButton
                    w: 40
                    text: "↺"
                    function clickAction() {
                        if (index === 0) {
                            updateVal1(bval1)
                        } else {
                            updateVal2(bval2)
                        }
                        joystick.update()
                    }
                }
            }
        }
    }
    ButtonWhite {
        text: "+"
        enabled: false
        w: 40
        x: parent.width * 0.95 - width
        y: joystick.y + joystick.height / 2
    }
    StyleSheet {id: style}

    function updateVal1(value) {
        val1 = value
        canva.layersModelUpdate('val1', value, idx, index)
    }
    function updateVal2(value) {
        val2 = value
        canva.layersModelUpdate('val2', value, idx, index)
    }
}
