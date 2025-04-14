import QtQuick 2.15

Rectangle {
    property double value
    property var updateFunc
    property string name: ""
    property string category: ""
    property string addName: ""
    property int index: -1
    property int propIndex: -1
    property int valIndex: -1
    property int subIndex: -1
    color: style.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    visible: false
    enabled: false
    radius: height / 4
    Label {
        width: valueRect.width - row.width - row.spacing
        x: parent.width * 0.05
        y: (valueRect.y - height) / 2
        text: parent.name
    }
    Rectangle {
        id: valueRect
        width: window.width / 1280 * 220
        height: window.width / 1280 * 30
        x: parent.width * 0.05
        y: parent.height - height - parent.radius / 3
        color: style.pinkWhite
        radius: width / 4
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
            color: style.lightDark
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

    StyleSheet {id: style}

    function buttonAction(text) {
        if (text === 'Apply') {
            const val0 = eval(textEdit.text)
            if (!doNotLog.includes(category)) logAction(val0)
            value = val0
            updateFunc(parseFloat(value))
            close()
        } else if (text === 'Close') {
            close()
        }
    }

    function open({value, name, updateFunc, category, index, propIndex, valIndex, subIndex, addName}) {
        canva.disableManipulator()
        this.value = value
        this.name = name
        this.category = category
        this.addName = addName
        this.index = index
        this.propIndex = propIndex
        this.valIndex = valIndex
        this.subIndex = subIndex
        this.updateFunc = updateFunc
        visible = true
        enabled = true
    }
    function close() {
        value = 0.0
        visible = false
        enabled = false
        updateFunc = undefined
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
    }
}
