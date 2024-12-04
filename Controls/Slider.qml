import QtQuick 2.15

Rectangle {
    width: window.width / 1280 * 220
    height: window.width / 1280 * 30
    radius: height / 2
    color: "#E6E6E6"
    border.width: 1
    border.color: "#E6E6E6"

    Rectangle {
        color: "#1A1A1A"
        border.width: 1
        border.color: "#E6E6E6"
        radius: parent.radius
        height: parent.height
        width: (val1 - min1) / (max1 - min1) * parent.width < height ? height : (val1 - min1) / (max1 - min1) * parent.width
    }
    MouseArea {
        id: area
        anchors.fill: parent
        onMouseXChanged: if (containsPress) clickAction()
    }

    function clickAction() {
        val1 = (area.mouseX / width) * (max1 - min1) + min1
        canva.layersModelUpdate('val1', val1, idx, index)
    }
}
