import QtQuick 2.15

Button {
    id: button
    property int w
    width: !!w ? window.width / 1280 * w : window.width / 1280 * 30
    height: !!w ? width / w * 20 : width / 30 * 20
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: "#E6E6E6"
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: "#242424"
                font.pixelSize: button.height / 20 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: "#D5D5D5"
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: "#333333"
                font.pixelSize: button.height / 20 * 12
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: "#CFCFCF"
                radius: width / 2
            }
            PropertyChanges {
                target: buttonText
                color: "#242424"
                font.pixelSize: button.height / 20 * 12
            }
        }
    ]
}
