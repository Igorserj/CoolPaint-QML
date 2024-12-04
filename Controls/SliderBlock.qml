import QtQuick 2.15

Rectangle {
    property string text: ""
    color: "#4C000000"
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    radius: height / 4
    Text {
        id: label
        text: parent.text
        height: window.width / 1280 * 30
        width: parent.width * 0.9
        font.family: "Helvetica"
        font.bold: true
        color: "#E6E6E6"
        font.pixelSize: parent.height / 80 * 12
        x: parent.radius / 3
        y: parent.radius / 3
        verticalAlignment: Text.AlignVCenter
    }
    Slider {
        id: slider
        y: parent.height - height - parent.radius / 3
        x: parent.width * 0.05
    }
    ButtonWhite {
        w: 40
        x: resetButton.x - width
        y: (slider.y - height) / 2
        text: val1.toFixed(2)
        function clickAction() {
            valueDialog.open(val1, updateAll)
        }
    }
    ButtonWhite {
        id: resetButton
        w: 40
        x: parent.width * 0.95 - width
        y: (slider.y - height) / 2
        text: "↺"
        function clickAction() {
            updateAll(bval1)
        }
    }
    function updateAll(value) {
        val1 = value
        canva.layersModelUpdate('val1', value, idx, index)
    }
}
