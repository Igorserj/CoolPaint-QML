import QtQuick 2.15

Rectangle {
    id: valueDialog
    property double value
    property var updateFunc
    property string name: ""
    property string category: ""
    property string addName: ""
    property int index: -1
    property int propIndex: -1
    property int valIndex: -1
    property int subIndex: -1
    color: window.style.currentTheme.darkGlass
    width: biggerSide * 240
    height: biggerSide * 80
    enabled: false
    radius: strictStyle ? 0 : height / 4
    state: "hidden"
    Behavior on opacity {
        PropertyAnimation {
            target: valueDialog
            property: "opacity"
            duration: strictStyle ? 0 : 200
        }
    }
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: valueDialog
                opacity: 1
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: valueDialog
                opacity: 0
            }
        }
    ]
    AcrylicBackground {
        id: acrylicBackground
        background: ui
        z: -1
    }
    MouseArea {
        id: dialogArea
        anchors.fill: parent
        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                close()
            } else if (event.key === Qt.Key_Return) {
                buttonAction("Apply")
            }
        }
    }
    Label {
        width: valueRect.width - row.width - row.spacing
        x: parent.width * 0.05
        y: (valueRect.y - height) / 2
        text: parent.name
    }
    Rectangle {
        id: valueRect
        width: biggerSide * 220
        height: biggerSide * 30
        x: parent.width * 0.05
        y: parent.height - height - valueDialog.height / 12//parent.radius / 3
        color: window.style.currentTheme.pinkWhite
        radius: strictStyle ? 0 : width / 4
        TextInput {
            id: textEdit
            clip: true
            validator: RegularExpressionValidator { regularExpression: /^-?\d+(?:[.]\d*?)?(?:\s*[+\-*/]\s*\d+(?:[.]\d*?)?)*$/ }
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            text: value.toFixed(2)
            font.family: "Helvetica"
            font.bold: true
            anchors.fill: parent
            color: window.style.currentTheme.lightDark
            font.pixelSize: parent.height / 25 * 12
            onAccepted: buttonAction('Apply')
        }
    }
    Row {
        id: row
        x: parent.width * 0.95 - width
        y: (valueRect.y - height) / 2
        spacing: parent.width / 40
        ButtonWhite {
            w: 40
            enabled: !["", ".", value.toFixed(2)].includes(textEdit.text.trim())
            text: "Apply"
            function clickAction() {
                buttonAction(text)
            }
        }
        ButtonWhite {
            w: 40
            text: "Close"
            function clickAction() {
                buttonAction(text)
            }
        }
    }

    function buttonAction(text) {
        if (text === 'Apply') {
            const logging = !doNotLog.includes(category)
            const val0 = eval(textEdit.text)
            if (logging) logAction(val0)
            value = val0
            updateFunc(parseFloat(value))
            if (logging) window.modelFunctions.autoSave()
            close()
        } else if (text === 'Close') {
            close()
        }
    }

    function open({value, name, updateFunc, category, index, propIndex, valIndex, subIndex, addName}) {
        disableMainArea()
        dialogArea.focus = true
        canvaFunctions.disableManipulator()
        valueDialog.value = value
        valueDialog.name = name
        valueDialog.category = category
        valueDialog.addName = addName
        valueDialog.index = index
        valueDialog.propIndex = propIndex
        valueDialog.valIndex = valIndex
        valueDialog.subIndex = subIndex
        valueDialog.updateFunc = updateFunc
        if (state !== "visible") acrylicBackground.activate()
        enabled = true
        state = "visible"
    }
    function close() {
        enableMainArea()
        value = 0.0
        name = ''
        enabled = false
        updateFunc = undefined
        state = "hidden"
        acrylicBackground.deactivate()
    }
    function logAction(val0) {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Set value of ${name} ${addName} to ${val0}`,//addName,
                              prevValue: {val: value},
                              value: {val: val0},
                              index: index, // layer number
                              subIndex: subIndex, // sublayer number
                              propIndex: propIndex, // sublayer property number
                              valIndex: valIndex
                          })
        stepIndex += 1
        actionsLog.historyBlockModelGeneration()
    }
}
