import QtQuick 2.15

Rectangle {
    id: switchBlock
    property string text: ""
    property double prevVal: -1
    color: window.style.currentTheme.darkGlass
    width: window.width / 1280 * 240
    radius: strictStyle ? 0 : height / 4
    state: category === "properties" ? "compact" : "default"
    states: [
        State {
            name: "default"
            PropertyChanges {
                target: slider
                x: slider.parent.width * 0.05
                y: slider.parent.height - slider.height - switchBlock.height / 8//slider.parent.radius / 2
            }
            PropertyChanges {
                target: switchBlock
                height: window.width / 1280 * 80
            }
            PropertyChanges {
                target: row
                x: row.parent.width * 0.95 - row.width
                y: (slider.y - row.height) / 2
            }
            PropertyChanges {
                target: label
                width: slider.width - row.width - row.spacing
                x: label.parent.width * 0.05
                y: (slider.y - label.height) / 2
                text: parent.text
            }
        },
        State {
            name: "compact"
            PropertyChanges {
                target: slider
                x: (slider.parent.width - width) - switchBlock.height / 4//slider.parent.radius
                y: (slider.parent.height - slider.height) / 2
                width: (slider.parent.width - switchBlock.height / 4/*slider.parent.radius*/) / 2
            }
            PropertyChanges {
                target: switchBlock
                height: window.width / 1280 * 40
            }
            PropertyChanges {
                target: row
                x: row.parent.width * 0.95 - row.width
                y: (row.parent.height - height) / 2
            }
            PropertyChanges {
                target: label
                width: label.parent.width - slider.width - switchBlock.height / 4//label.parent.radius
                x: label.parent.width * 0.05
                y: (parent.height - label.height) / 2
                text: parent.text
            }
        }
    ]
    Component.onCompleted: {
        prevVal = val1
    }
    Label {
        id: label
        text: parent.text
    }
    Row {
        id: row
        spacing: parent.width / 40
        ButtonWhite {
            w: 40
            text: "↺"
            function clickAction() {
                val1 = bval1
                updateAll(bval1)
                if (!doNotLog.includes(category) && prevVal !== (val1 === 0 ? 1 : 0)) {
                    logAction()
                    modelFunctions.autoSave()
                }
            }
        }
    }
    ButtonSwitch {
        id: slider
    }

    function updateAll(value) {
        val1 = value
        updateVal(value)
    }

    function updateVal(val1) {
        if (category === "layer") {
            canvaFunctions.layersModelUpdate('val1', val1, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
        }
    }
    function logAction() {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Reset value of ${name}`,
                              prevValue: {val: val1 === 0 ? 1 : 0},
                              value: {val: val1},
                              index: leftPanelFunctions.getLayerIndex(), // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
        actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
    }
}
