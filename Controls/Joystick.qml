import QtQuick 2.15

Rectangle {
    property alias stickArea: stickArea
    property int w
    color: "#E6E6E6"
    width: !!w ? window.width / 1280 * w : window.width / 1280 * 115
    height: width
    radius: stick.radius
    clip: true

    Rectangle {
        id: stick
        width: 30
        height: 30
        radius: width / 3
        color: "#1A1A1A"
        x: ((val1 - min1) / (max1 - min1)) * (parent.width - stick.width)
        y: ((val2 - min2) / (max2 - min2)) * (parent.height - stick.height)
    }
    MouseArea {
        id: stickArea
        anchors.fill: parent
        onMouseXChanged: stick.x = xStick(true, stickArea.mouseX)
        onMouseYChanged: stick.y = yStick(true, stickArea.mouseY)
    }

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
    function update() {
        stick.x = xStick(false)
        stick.y = yStick(false)
    }
}
