import QtQuick 2.15

Button {
    id: button
    property int w: 30
    width: buttonText.width * 1.1 > window.width / 1280 * w ? buttonText.width + window.width / 1280 * 10 : window.width / 1280 * w
    height: window.width / 1280 * w / 2
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.pinkWhite
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.lightDark
                font.pixelSize: button.height / 20 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.pinkWhiteDim
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.lightDark
                font.pixelSize: button.height / 20 * 12
            }
        },
        State {
            name: "hovered"
            when: area.containsMouse && button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.pinkWhiteAccent
                radius: width / 2
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.lightDark
                font.pixelSize: button.height / 20 * 12
            }
        }
    ]
    StyleSheet {id: style}
}
