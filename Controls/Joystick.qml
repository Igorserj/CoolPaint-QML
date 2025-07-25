import QtQuick 2.15

Rectangle {
    id: joystick
    property alias stickArea: stickArea
    property int w: block.w / 240 * 115
    property var prevVal: [-1, -1]
    property var isReleased: [true, true]
    property var stickSpeed: [0, 0]
    readonly property real curVal1: val1
    readonly property real curVal2: val2
    onCurVal1Changed: stickSpeed[0] = Math.abs(prevVal[0] - val1) / (max1 - min1) * 250
    onCurVal2Changed: stickSpeed[1] = Math.abs(prevVal[1] - val2) / (max2 - min2) * 250
    width: biggerSide * w
    height: biggerSide * w
    clip: true
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !stickArea.containsMouse && joystick.enabled
            PropertyChanges {
                target: joystick
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : width / 8
            }
            PropertyChanges {
                target: stick
                radius: strictStyle ? 0 : stick.width / 3
            }
        },
        State {
            name: "hovered"
            when: stickArea.containsMouse && joystick.enabled
            PropertyChanges {
                target: joystick
                color: window.style.currentTheme.pinkWhiteAccent
                radius: strictStyle ? 0 : width / 6
            }
            PropertyChanges {
                target: stick
                radius: strictStyle ? 0 : stick.width / 2
            }
        }
    ]
    Behavior on color {
        ColorAnimation {
            duration: strictStyle ? 0 : 200
        }
    }
    Behavior on radius {
        PropertyAnimation {
            target: joystick
            property: "radius"
            duration: 200
        }
    }
    Rectangle {
        id: stick
        width: height
        height: biggerSide * 30
        radius: strictStyle ? 0 : width / 3
        color: window.style.currentTheme.lightDark
        x: ((val1 - min1) / (max1 - min1)) * parent.width - stick.width / 2
        y: ((val2 - min2) / (max2 - min2)) * parent.height - stick.height / 2
        Behavior on radius {
            PropertyAnimation {
                target: stick
                property: "radius"
                duration: 200
            }
        }
        Behavior on x {
            PropertyAnimation {
                target: stick
                property: "x"
                duration: strictStyle ? 0 : stickSpeed[0]
                easing.type: "OutCirc"
            }
        }
        Behavior on y {
            PropertyAnimation {
                target: stick
                property: "y"
                duration: strictStyle ? 0 : stickSpeed[1]
                easing.type: "OutCirc"
            }
        }
    }
    MouseArea {
        id: stickArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        onMouseXChanged: if (containsPress) {
                             xStick(true, mouseX)
                             updateX()
                         }
        onMouseYChanged: if (containsPress) {
                             yStick(true, mouseY)
                             updateY()
                         }
        onReleased: if (!doNotLog.includes(category)) {
                        logAction()
                        window.modelFunctions.autoSave()
                    }
    }

    function xStick(pressed, mouseX = 0) {
        if (pressed) {
            if (isReleased[0]) prevVal[0] = val1
            isReleased[0] = false
            const newVal = (mouseX / width) * (max1 - min1) + min1
            val1 = newVal > max1 ? max1 : newVal < min1 ? min1 : newVal
            canvaFunctions.layersModelUpdate('val1', val1, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
        }
        return val1
    }
    function updateX() {
        stick.x = Qt.binding(() => (val1 - min1) / (max1 - min1) * width - stick.width / 2)
    }
    function yStick(pressed, mouseY = 0) {
        if (pressed) {
            if (isReleased[1]) prevVal[1] = val2
            isReleased[1] = false
            const newVal = (mouseY / height) * (max2 - min2) + min2
            val2 = newVal > max2 ? max2 : newVal < min2 ? min2 : newVal
            canvaFunctions.layersModelUpdate('val2', val2, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
        }
        return val2
    }
    function updateY() {
        stick.y = Qt.binding(() => (val2 - min2) / (max2 - min2) * height - stick.height / 2)
    }
    function updating() {
        updateX()
        updateY()
    }
    function logAction() {
        console.log(prevVal, [val1, val2], index)
        actionsLog.trimModel(stepIndex)
        const layerIndex = leftPanelFunctions.getLayerIndex()
        if (val1 !== prevVal[0]) {
            actionsLog.append({
                                  block: category,
                                  name: `Set value of ${name} X to ${val1.toFixed(2)}`,
                                  prevValue: {val: prevVal[0]},
                                  value: {val: val1},
                                  index: layerIndex, // layer number
                                  subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                                  propIndex: index, // sublayer property number
                                  valIndex: 0
                              })
            stepIndex += 1
            isReleased[0] = true
        }
        if (val2 !== prevVal[1]) {
            actionsLog.append({
                                  block: category,
                                  name: `Set value of ${name} Y to ${val2.toFixed(2)}`,
                                  prevValue: {val: prevVal[1]},
                                  value: {val: val2},
                                  index: layerIndex, // layer number
                                  subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                                  propIndex: index, // sublayer property number
                                  valIndex: 1
                              })
            stepIndex += 1
            isReleased[1] = true
        }
        actionsLog.historyBlockModelGeneration()
    }
}
