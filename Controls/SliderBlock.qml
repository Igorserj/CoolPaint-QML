import QtQuick 2.15

Rectangle {
    property string text: ""
    color: style.currentTheme.darkGlass
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
                popUpFunctions.openValueDialog({
                                     value: val1,
                                     name: name,
                                     updateFunc: updateAll,
                                     category: category,
                                     index: leftPanelFunctions.getLayerIndex(),
                                     propIndex: index,
                                     subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                     addName: "",
                                     valIndex: 0
                                 })
            }
        }
        ButtonWhite {
            w: 40
            text: "↺"
            function clickAction() {
                if (!doNotLog.includes(category)) logAction(bval1)
                updateAll(bval1)
                modelFunctions.autoSave()
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
            canvaFunctions.layersModelUpdate('val1', val1, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
        } else if (category === "view") {
            if (name === "Scale") {
                canvaFunctions.setScaling(val1)
            }
        } else if (category === "export") {
            if (name === "Width") {
                canvaFunctions.setImageSize(val1, -1)
            } else if (name === "Height") {
                canvaFunctions.setImageSize(-1, val1)
            }
        }
    }
    function logAction(val0 = -1) {
        console.log(val0, val1)
        if (val0 !== val1) {
            actionsLog.trimModel(stepIndex)
            actionsLog.append({
                                  block: category,
                                  name: `Reset value of ${name}`,
                                  prevValue: {val: val1},
                                  value: {val: val0},
                                  index: leftPanelFunctions.getLayerIndex, // layer number
                                  subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                                  propIndex: index, // sublayer property number
                                  valIndex: 0
                              })
            stepIndex += 1
        }
    }
}
