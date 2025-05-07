import QtQuick 2.15

Rectangle {
    id: block
    property string text: ""
    property int blockIndex: index
    color: style.currentTheme.darkGlass
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
                        console.log("blockIndex", blockIndex)
                        const layerIndex = leftPanelFunctions.getLayerIndex()
                        // console.log("name", name)
                        if (index === 0) {
                            popUpFunctions.openValueDialog({
                                                 value: val1,
                                                 name: name,
                                                 updateFunc: updateVal1,
                                                 category: category,
                                                 index: layerIndex,
                                                 propIndex: blockIndex,
                                                 subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                                 addName: "X",
                                                 valIndex: index
                                             })
                        } else if (index === 1) {
                            popUpFunctions.openValueDialog({
                                                 value: val2,
                                                 name: name,
                                                 updateFunc: updateVal2,
                                                 category: category,
                                                 index: layerIndex,
                                                 propIndex: blockIndex,
                                                 subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                                 addName: "Y",
                                                 valIndex: index
                                             })
                        } else {
                            const model = {
                                min1: min1,
                                max1: max1,
                                val1: val1,
                                min2: min2,
                                max2: max2,
                                val2: val2,
                                name: name,
                                idx: layerIndex,
                                index: layerIndex,
                                propIndex: blockIndex,
                                parentIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                activated: true,
                                category: category,
                                joy: joystick
                            }
                            canvaFunctions.enableManipulator(joystick, model)
                        }
                    }
                }
                ButtonWhite {
                    id: resetButton
                    w: 40
                    visible: index !== 2
                    text: "↺"
                    function clickAction() {
                        const logging = !doNotLog.includes(category)
                        if (index === 0) {
                            if (logging) logActionX(bval1)
                            updateVal1(bval1)
                        } else if (index === 1) {
                            if (logging) logActionY(bval2)
                            updateVal2(bval2)
                        }
                        joystick.updating()
                        if (logging) modelFunctions.autoSave()
                    }
                }
            }
        }
    }
    StyleSheet {id: style}

    function updateVal1(value) {
        val1 = value
        canvaFunctions.layersModelUpdate('val1', value, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
    }
    function updateVal2(value) {
        val2 = value
        canvaFunctions.layersModelUpdate('val2', value, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
    }
    function logActionX(val0) {
        console.log(val1, val0)
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Reset value of ${name} X`,
                              prevValue: {val: val1},
                              value: {val: val0},
                              index: leftPanelFunctions.getLayerIndex(), // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
    }
    function logActionY(val0) {
        console.log(val2, val0)
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Reset value of ${name} Y`,
                              prevValue: {val: val2},
                              value: {val: val0},
                              index: leftPanelFunctions.getLayerIndex(), // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 1
                          })
        stepIndex += 1
    }
}
