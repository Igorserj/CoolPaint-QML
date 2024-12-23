import QtQuick 2.15

Rectangle {
    id: joystick
    property alias stickArea: stickArea
    property int w: 115
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
                color: style.pinkWhite
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
                color: style.pinkWhiteAccent
                radius: width / 6
            }
            PropertyChanges {
                target: stick
                radius: stick.width / 2
            }
        }/*,
        State {
            name: "disabled"
            when: stickArea.containsMouse && joystick.enabled
            PropertyChanges {
                target: joystick
                color: style.pinkWhiteAccent
                radius: stick.radius
            }
        }*/
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
        width: 30
        height: 30
        radius: width / 3
        color: style.lightDark
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
        onMouseXChanged: if (containsPress) stick.x = xStick(true, mouseX)
        onMouseYChanged: if (containsPress) stick.y = yStick(true, mouseY)
    }
    StyleSheet {id: style}

    function xStick(pressed, mouseX = 0) {
        if (pressed) {
            const newVal = (mouseX / width) * (max1 - min1) + min1
            val1 = newVal > max1 ? max1 : newVal < min1 ? min1 : newVal
            canva.layersModelUpdate('val1', val1, idx, index)
            return mouseX - stick.width / 2
        } else {
            return (val1 - min1) / (max1 - min1) * width - stick.width / 2
        }
    }
    function yStick(pressed, mouseY = 0) {
        if (pressed) {
            const newVal = (mouseY / height) * (max2 - min2) + min2
            val2 = newVal > max2 ? max2 : newVal < min2 ? min2 : newVal
            canva.layersModelUpdate('val2', val2, idx, index)
            return mouseY - stick.height / 2
        } else {
            return (val2 - min2) / (max2 - min2) * height - stick.height / 2
        }
    }
    function updating() {
        stick.x = xStick(false)
        stick.y = yStick(false)
    }
}
