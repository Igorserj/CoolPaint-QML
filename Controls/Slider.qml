import QtQuick 2.15

Rectangle {
    id: slider
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
                color: style.pinkWhite
                border.width: 1
                border.color: style.pinkWhite
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && slider.enabled
            PropertyChanges {
                target: slider
                radius: slider.height / 2
                color: style.pinkWhiteAccent
                border.width: 1
                border.color: style.pinkWhiteAccent
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
        color: style.lightDark
        border.width: 1
        border.color: style.pinkWhite
        radius: parent.radius
        height: parent.height
        width: pillWidth()
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onMouseXChanged: if (containsPress) clickAction()
    }
    StyleSheet {id: style}

    function clickAction() {
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
