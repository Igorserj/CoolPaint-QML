import QtQuick 2.15

Rectangle {
    id: block
    property string text: ""
    property int blockIndex: index
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
                        console.log("blockIndex", blockIndex)
                        if (index === 0) {
                            valueDialog.open({
                                                 value: val1,
                                                 name: name,
                                                 updateFunc: updateVal1,
                                                 category: category,
                                                 index: leftPanel.layerIndex,//idx,//leftPanel.layerIndex,//typeof(parentIndex) !== "undefined" ? parentIndex : -1,
                                                 propIndex: blockIndex,
                                                 subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                                 addName: "X",
                                                 valIndex: index
                                             })
                        } else if (index === 1) {
                            valueDialog.open({
                                                 value: val2,
                                                 name: name,
                                                 updateFunc: updateVal2,
                                                 category: category,
                                                 index: leftPanel.layerIndex,//idx,//leftPanel.layerIndex,//typeof(parentIndex) !== "undefined" ? parentIndex : -1,
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
                                idx: leftPanel.layerIndex,//idx,
                                index: leftPanel.layerIndex,//idx,//index,
                                propIndex: blockIndex,
                                subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                // parentIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1,
                                activated: true,
                                category: category,
                                joy: joystick
                            }
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
                            if (!doNotLog.includes(category)) logActionX(bval1)
                            updateVal1(bval1)
                        } else if (index === 1) {
                            if (!doNotLog.includes(category)) logActionY(bval2)
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
    function logActionX(val0) {
        console.log(val1, val0)
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Reset value of ${name} X`,
                              prevValue: {val: val1},
                              value: {val: val0},
                              index: leftPanel.layerIndex,//idx, // layer number
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
                              index: leftPanel.layerIndex,//idx, // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 1
                          })
        stepIndex += 1
    }
}
