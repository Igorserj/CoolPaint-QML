import QtQuick 2.15

Rectangle {
    id: slider
    property double prevVal: -1
    property bool isReleased: true
    property real sliderSpeed: 250
    readonly property real val: val1
    width: biggerSide * w / 240 * 215
    height: biggerSide * (w / 8)
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && slider.enabled
            PropertyChanges {
                target: slider
                radius: strictStyle ? 0 : slider.height / 2.5
                color: window.style.currentTheme.pinkWhite
                border.width: 1
                border.color: window.style.currentTheme.pinkWhite
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && slider.enabled
            PropertyChanges {
                target: slider
                radius: strictStyle ? 0 : slider.height / 2
                color: window.style.currentTheme.pinkWhiteAccent
                border.width: 1
                border.color: window.style.currentTheme.pinkWhiteAccent
            }
        }
    ]
    onValChanged: sliderUpdating()
    Component.onCompleted: sliderUpdating()

    Behavior on color {
        ColorAnimation {
            duration: strictStyle ? 0 : 200
        }
    }
    Behavior on radius {
        PropertyAnimation {
            target: slider
            property: "radius"
            duration: 200
        }
    }
    Rectangle {
        id: pill
        color: window.style.currentTheme.lightDark
        border.width: 1
        border.color: window.style.currentTheme.pinkWhite
        radius: parent.radius
        height: parent.height
        Behavior on width {
            PropertyAnimation {
                target: pill
                property: "width"
                duration: strictStyle ? 0 : sliderSpeed
                easing.type: "OutCirc"
            }
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onMouseXChanged: if (containsPress) pressAction()
        onReleased: {
            clickAction(name, type, index, [val1, val2], false)
            if (!doNotLog.includes(category) && prevVal !== val1) {
                logAction()
                window.modelFunctions.autoSave()
            }
            isReleased = true
        }
    }

    function logAction() {
        console.log(prevVal, val1)
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Set value of ${name} to ${val1.toFixed(2)}`,
                              prevValue: {val: prevVal},
                              value: {val: val1},
                              index: leftPanelFunctions.getLayerIndex(), // layer number
                              subIndex: typeof(parentIndex) !== 'undefined' ? parentIndex : -1, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
        actionsLog.historyBlockModelGeneration()
        prevVal = parseFloat(val1)
    }
    function pressAction() {
        if (isReleased) prevVal = parseFloat(val1)
        isReleased = false
        val1 = (area.mouseX / width) * (max1 - min1) + min1
        updateVal(val1)
    }
    function sliderUpdating() {
        const newWidth = (val1 - min1) / (max1 - min1) * parent.width
        sliderSpeed = Math.abs(pill.width - newWidth) / parent.width * 250
        if (newWidth < height) pill.width = height
        else if (newWidth > width) pill.width = width
        else pill.width = newWidth
    }
}
