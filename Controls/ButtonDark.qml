import QtQuick 2.15

Button {
    id: button
    property int w: 240
    width: window.width / 1280 * w
    height: window.width / 1280 * w / 8
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: style.darkGlass
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: style.pinkWhiteAccent
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: style.darkGlassDim
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: style.pinkWhite
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: style.darkGlassAccent
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: style.pinkWhiteAccent
                font.pixelSize: button.height / 30 * 12
            }
        }
    ]
    StyleSheet {id: style}
}
