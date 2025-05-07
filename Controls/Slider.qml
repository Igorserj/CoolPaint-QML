import QtQuick 2.15

Rectangle {
    id: slider
    property double prevVal: -1
    property bool isReleased: true
    width: window.width / 1280 * 220
    height: window.width / 1280 * 30
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && slider.enabled
            PropertyChanges {
                target: slider
                radius: slider.height / 2.5
                color: style.currentTheme.pinkWhite
                border.width: 1
                border.color: style.currentTheme.pinkWhite
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && slider.enabled
            PropertyChanges {
                target: slider
                radius: slider.height / 2
                color: style.currentTheme.pinkWhiteAccent
                border.width: 1
                border.color: style.currentTheme.pinkWhiteAccent
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
            target: slider
            property: "radius"
            duration: 200
        }
    }
    Rectangle {
        color: style.currentTheme.lightDark
        border.width: 1
        border.color: style.currentTheme.pinkWhite
        radius: parent.radius
        height: parent.height
        width: pillWidth()
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onMouseXChanged: if (containsPress) clickAction()
        onReleased: if (!doNotLog.includes(category)) {
                        logAction()
                        modelFunctions.autoSave()
                    }
    }
    StyleSheet {id: style}

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
        prevVal = parseFloat(val1)
        isReleased = true
    }
    function clickAction() {
        if (isReleased) prevVal = parseFloat(val1)
        isReleased = false
        val1 = (area.mouseX / width) * (max1 - min1) + min1
        updateVal(val1)
    }
    function pillWidth() {
        const newWidth = (val1 - min1) / (max1 - min1) * parent.width
        if (newWidth < height) return height
        else if (newWidth > width) return width
        else return newWidth
    }
}
