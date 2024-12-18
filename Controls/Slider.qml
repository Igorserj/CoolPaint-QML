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
        // State {
        //     name: "disabled"
        //     when: !button.enabled
        //     PropertyChanges {
        //         target: button
        //         color: "#D5D5D5"
        //         radius: width / 4
        //     }
        // },
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
        width: (val1 - min1) / (max1 - min1) * parent.width < height ? height : (val1 - min1) / (max1 - min1) * parent.width
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onMouseXChanged: if (containsPress) clickAction()
    }

    function clickAction() {
        val1 = (area.mouseX / width) * (max1 - min1) + min1
        updateVal(val1)
    }
    StyleSheet {id: style}
}
