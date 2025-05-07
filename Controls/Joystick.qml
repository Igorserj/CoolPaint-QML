import QtQuick 2.15

Rectangle {
    id: joystick
    property alias stickArea: stickArea
    property int w: 115
    property var prevVal: [-1, -1]//[val1, val2]
    property var isReleased: [true, true]
    width: window.width / 1280 * w
    height: window.width / 1280 * w
    clip: true
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !stickArea.containsMouse && joystick.enabled
            PropertyChanges {
                target: joystick
                color: style.currentTheme.pinkWhite
                radius: width / 8
            }
            PropertyChanges {
                target: stick
                radius: stick.width / 3
            }
        },
        State {
            name: "hovered"
            when: stickArea.containsMouse && joystick.enabled
            PropertyChanges {
                target: joystick
                color: style.currentTheme.pinkWhiteAccent
                radius: width / 6
            }
            PropertyChanges {
                target: stick
                radius: stick.width / 2
            }
        }
    ]
    Behavior on color {
        ColorAnimation {
            duration: 200
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
        height: window.width / 1280 * 30
        radius: width / 3
        color: style.currentTheme.lightDark
        x: ((val1 - min1) / (max1 - min1)) * (parent.width - stick.width)
        y: ((val2 - min2) / (max2 - min2)) * (parent.height - stick.height)
        Behavior on radius {
            PropertyAnimation {
                target: stick
                property: "radius"
                duration: 200
            }
        }
    }
    MouseArea {
        id: stickArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        onMouseXChanged: if (containsPress) stick.x = xStick(true, mouseX).coord
        onMouseYChanged: if (containsPress) stick.y = yStick(true, mouseY).coord
        onReleased: if (!doNotLog.includes(category)) {
                        logAction()
                        modelFunctions.autoSave()
                    }
    }
    StyleSheet {id: style}

    function xStick(pressed, mouseX = 0) {
        if (pressed) {
            if (isReleased[0]) prevVal[0] = val1
            isReleased[0] = false
            const newVal = (mouseX / width) * (max1 - min1) + min1
            val1 = newVal > max1 ? max1 : newVal < min1 ? min1 : newVal
            canvaFunctions.layersModelUpdate('val1', val1, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
            return {
                coord: mouseX - stick.width / 2,
                value: val1
            }
        } else {
            return {
                coord: (val1 - min1) / (max1 - min1) * width - stick.width / 2,
                value: val1
            }
        }
    }
    function yStick(pressed, mouseY = 0) {
        if (pressed) {
            if (isReleased[1]) prevVal[1] = val2
            isReleased[1] = false
            const newVal = (mouseY / height) * (max2 - min2) + min2
            val2 = newVal > max2 ? max2 : newVal < min2 ? min2 : newVal
            canvaFunctions.layersModelUpdate('val2', val2, idx, index, typeof(parentIndex) !== 'undefined' ? parentIndex : -1)
            return {
                coord: mouseY - stick.height / 2,
                value: val2
            }
        } else {
            return {
                coord: (val2 - min2) / (max2 - min2) * height - stick.height / 2,
                value: val2
            }
        }
    }
    function updating() {
        stick.x = xStick(false).coord
        stick.y = yStick(false).coord
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
    }
}
