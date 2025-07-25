import QtQuick 2.15

Rectangle {
    id: button
    property alias area: area
    property int w: 240
    width: biggerSide * w
    height: biggerSide * w / 20
    color: window.style.currentTheme.darkGlass
    radius: strictStyle ? 0 : width / 24
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !(area.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.darkGlass
                radius: strictStyle ? 0 : width / 24
                width: biggerSide * w
                height: window.height * 0.001
            }
            PropertyChanges {
                target: area
                height: window.height * 0.006
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.darkGlassDim
                radius: strictStyle ? 0 : width / 24
            }
        },
        State {
            name: "hovered"
            when: (area.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.darkGlassAccent
                radius: strictStyle ? 0 : width / 4
                width: biggerSide * w
                height: biggerSide * w / 20
            }
            PropertyChanges {
                target: area
                height: button.height + window.height * 0.005
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
            target: button
            property: "radius"
            duration: 200
        }
    }
    Behavior on height {
        PropertyAnimation {
            target: button
            property: "height"
            duration: 200
        }
    }
    MouseArea {
        id: area
        y: (parent.height - height) / 2
        width: parent.width
        height: parent.height + window.height * 0.005
        enabled: button.enabled
        hoverEnabled: button.enabled
        onClicked: clickHandler()
    }

    function clickHandler() {
        clickAction()
    }
    function clickAction() {}
}
