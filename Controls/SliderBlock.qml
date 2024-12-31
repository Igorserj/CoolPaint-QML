import QtQuick 2.15

Rectangle {
    property string text: ""
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    radius: height / 4
    Label {
        width: slider.width - row.width - row.spacing
        x: parent.width * 0.05
        y: (slider.y - height) / 2
        text: parent.text
    }
    Slider {
        id: slider
        x: parent.width * 0.05
        y: parent.height - height - parent.radius / 2
    }
    Row {
        id: row
        x: parent.width * 0.95 - width
        y: (slider.y - height) / 2
        spacing: parent.width / 40
        ButtonWhite {
            w: 40
            text: val1.toFixed(2)
            function clickAction() {
                valueDialog.open(val1, name, updateAll)
            }
        }
        ButtonWhite {
            w: 40
            text: "↺"
            function clickAction() {
                updateAll(bval1)
            }
        }
    }
    StyleSheet {id: style}

    function updateAll(value) {
        val1 = value
        updateVal(value)
    }
    function updateVal(val1) {
        if (category === "layer") {
            canva.layersModelUpdate('val1', val1, idx, index)
        } else if (category === "view") {
            if (name === "Scale") {
                canva.scaling = val1
            }
        } else if (category === "export") {
            if (name === "Width") {
                canva.setImageSize(val1, -1)
            } else if (name === "Height") {
                canva.setImageSize(-1, val1)
            }
        }
    }
}
