import QtQuick 2.15

Rectangle {
    id: block
    property string text: ""
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 160
    radius: height / 6
    Label {
        width: joystick.width
        x: parent.width * 0.05
        y: (joystick.y - height) / 2
        text: parent.text
    }
    Joystick {
        id: joystick
        x: parent.width * 0.05
        y: parent.height - height - parent.radius / 2
    }
    Column {
        x: parent.width * 0.95 - width
        y: joystick.y + (joystick.height - height) / 2
        spacing: block.height / 40
        Repeater {
            model: 3
            delegate: Row {
                spacing: block.width / 40
                ButtonWhite {
                    w: 40
                    text: index === 0 ? val1.toFixed(2) : index === 1 ? val2.toFixed(2) : "+"
                    function clickAction() {
                        if (index === 0)
                            valueDialog.open(val1, name, updateVal1)
                        else if (index === 1)
                            valueDialog.open(val2, name, updateVal2)
                        else {
                            const model = { min1: min1, max1: max1, val1: val1, min2: min2, max2: max2, val2: val2, idx: idx, index: index, activated: true, joy: joystick }
                            canva.enableManipulator(joystick, model)
                        }
                    }
                }
                ButtonWhite {
                    id: resetButton
                    w: 40
                    visible: index !== 2
                    text: "↺"
                    function clickAction() {
                        if (index === 0) {
                            updateVal1(bval1)
                        } else if (index === 1) {
                            updateVal2(bval2)
                        }
                        joystick.updating()
                    }
                }
            }
        }
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
