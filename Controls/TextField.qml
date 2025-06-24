import QtQuick 2.15

Rectangle {
    id: textFieldRect
    property real w: 240
    property string text: ""
    color: window.style.currentTheme.darkGlass
    width: window.width / 1280 * w
    height: window.width / 1280 * (w / 3.5)
    radius: strictStyle ? 0 : height / 4

    MouseArea {
        id: dialogArea
        anchors.fill: parent
        Keys.onPressed: {
            if (event.key === Qt.Key_Return) {
                apply()
            }
        }
    }
    Label {
        id: label
        width: row.width
        x: parent.width * 0.05
        text: textFieldRect.text.split(" ")[0]
    }
    Row {
        id: row
        x: parent.width * 0.95 - width
        y: label.height
        spacing: parent.width / 40
        Rectangle {
            id: valueRect
            width: (window.width / 1280) * 0.9 * (w - 40) - row.spacing
            height: (window.width / 1280) * (w / 8)
            color: window.style.currentTheme.pinkWhite
            radius: strictStyle ? 0 : width / 4
            TextInput {
                id: textEdit
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                // text: textFieldRect.text.split(" ")[1]
                text: textFieldRect.text.substring(textFieldRect.text.indexOf(" ") + 1)
                font.family: "Helvetica"
                font.bold: true
                anchors.fill: parent
                color: window.style.currentTheme.lightDark
                font.pixelSize: parent.height / 25 * 12
            }
        }
        ButtonWhite {
            w: 40
            text: "Apply"
            function clickAction() {
                apply()
            }
        }
    }

    function apply() {
        const prevVal = textFieldRect.text.substring(textFieldRect.text.indexOf(" ") + 1)
        controlsAction({name: label.text, type, index, val1: textEdit.text, val2})
        if (textEdit.text !== prevVal) {
            logAction(prevVal)
            modelFunctions.autoSave()
        }
        textFieldRect.text = `Alias ${textEdit.text}`
        textEdit.text = Qt.binding(() => textFieldRect.text.substring(textFieldRect.text.indexOf(" ") + 1))
    }

    function logAction(value) {
        const layerIndex = leftPanelFunctions.getLayerIndex()
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Renamed layer ${layerIndex} to ${textEdit.text}`,
                              prevValue: {val: value},
                              value: {val: textEdit.text},
                              index: layerIndex, // layer number
                              subIndex: -1, // sublayer number
                              propIndex: -1, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
        actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
    }
}
