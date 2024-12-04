import QtQuick 2.15

Button {
    id: button
    property int w
    height: !!w ? width / w * 30 : width / 240 * 30
    width: !!w ? window.width / 1280 * w : window.width / 1280 * 240
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: "#4C000000"
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: "#E6E6E6"
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: "#4C242424"
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: "#E6E6E6"
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: "#4CE6E6E6"
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: "#E6E6E6"
                font.pixelSize: button.height / 30 * 12
            }
        }
    ]
}
