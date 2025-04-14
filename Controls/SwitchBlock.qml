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
    ButtonSwitch {
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
            text: "↺"
            function clickAction() {
                val1 = bval1
                updateAll(bval1)
                if (!doNotLog.includes(category)) logAction()
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
            if (name === "Mirroring") {
                canva.mirroring = val1
            } else if (name === "Smoothing") {
                canva.smoothing = val1
                canva.reDraw()
            }
        } else if (category === "export") {
            if (name === "Preserve aspect fit") {
                canva.preserveAspect = val1
            }
        }
    }
    function logAction() {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Reset value of ${name}`,
                              prevValue: {val: val1 === 0 ? 1 : 0},
                              value: {val: val1},
                              index: leftPanel.layerIndex,//typeof(idx) !== "undefined" ? idx : -1, // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
    }
}
