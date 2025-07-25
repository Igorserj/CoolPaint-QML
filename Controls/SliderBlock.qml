import QtQuick 2.15

Rectangle {
    property string text: ""
    property int w: 240
    color: window.style.currentTheme.darkGlass
    width: biggerSide * w
    height: biggerSide * w / (240 / 85)
    radius: strictStyle ? 0 : height / 4
    Label {
        width: slider.width - row.width - row.spacing * 2
        x: parent.width * 0.05
        y: (slider.y - height) / 2
        text: parent.text
    }
    Slider {
        id: slider
        // x: parent.width * 0.05
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height - height - height / 2
    }
    Row {
        id: row
        x: parent.width * 0.95 - width
        y: (slider.y - height) / 2
        spacing: parent.width / 40
        ButtonWhite {
            id: rowButton
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
                resetAction()
            }
        }
    }

    function updateAll(value) {
        val1 = value
        updateVal(value)
    }
    function resetAction() {
        let pi = -1
        if (typeof(parentIndex) !== "undefined") pi = parentIndex
        clickAction({
                        name,
                        type,
                        index,
                        "val1": bval1,
                        "val2": pi
                    })
        if (!doNotLog.includes(category)) logAction(bval1)
        updateAll(bval1)
        window.modelFunctions.autoSave()
    }
    function updateVal(val1) {
        clickAction()
    }
    function logAction(val0 = -1) {
        if (val0 !== val1) {
            actionsLog.trimModel(stepIndex)
            actionsLog.append({
                                  block: category,
                                  name: `Reset value of ${name}`,
                                  prevValue: { val: val1 },
                                  value: { val: val0 },
                                  index: leftPanelFunctions.getLayerIndex(), // layer number
                                  subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                                  propIndex: index, // sublayer property number
                                  valIndex: 0
                              })
            stepIndex += 1
            actionsLog.historyBlockModelGeneration()
        }
    }
}
