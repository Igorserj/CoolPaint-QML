import QtQuick 2.15

Rectangle {
    id: buttonSwitch
    property int w: 220
    width: window.width / 1280 * w
    height: window.width / 1280 * w / 7.3
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && buttonSwitch.enabled
            PropertyChanges {
                target: buttonSwitch
                radius: buttonSwitch.height / 2.5
                color: style.pinkWhite
                border.width: 1
                border.color: style.pinkWhite
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && buttonSwitch.enabled
            PropertyChanges {
                target: buttonSwitch
                radius: buttonSwitch.height / 2
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
            target: buttonSwitch
            property: "radius"
            duration: 200
        }
    }

    Rectangle {
        id: pill
        color: style.lightDark
        border.width: 1
        border.color: style.pinkWhite
        radius: parent.radius
        height: parent.height
        width: placeholder.x + placeholder.width + parent.width * 0.05
        x: val1 === min1 ? 0 : parent.width - width
        Behavior on x {
            PropertyAnimation {
                target: pill
                properties: "x,width"
                duration: 250
                easing.type: Easing.OutExpo
            }
        }
    }
    Item {
        id: placeholder
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        height: parent.height
        width: children[0].contentWidth
        Text {
            text: val1 === 0 ? "OFF" : "ON"
            height: parent.height
            font.family: "Helvetica"
            font.bold: true
            color: style.pinkWhiteAccent
            font.pixelSize: parent.height / 40 * 12
            x: parent.radius / 3
            y: parent.radius / 3
            verticalAlignment: Text.AlignVCenter
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onMouseXChanged: if (containsPress) clickAction()
    }

    function clickAction() {
        if (val1 === min1) val1 = max1
        else if (val1 === max1) val1 = min1
        updateVal(val1)
    }
    StyleSheet {id: style}
}
