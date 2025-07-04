import QtQuick 2.15

Button {
    id: button
    property int w: 30
    width: buttonText.width * 1.1 > window.width / 1280 * (w <= 40 ? w : w / 2) ? buttonText.width + window.width / 1280 * 10 : window.width / 1280 * (w <= 40 ? w : w / 2)
    height: window.width / 1280 * w / 2
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !(area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : width / 4
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.lightDark
                font.pixelSize: window.width / 1280 * w / 2 / 20 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.pinkWhiteDim
                radius: strictStyle ? 0 : width / 4
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.lightDark
                font.pixelSize: window.width / 1280 * w / 2 / 20 * 12
            }
        },
        State {
            name: "hovered"
            when: (area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.pinkWhiteAccent
                radius: strictStyle ? 0 : width / 2
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.lightDark
                font.pixelSize: window.width / 1280 * w / 2 / 20 * 12
            }
        }
    ]
}
