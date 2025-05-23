import QtQuick 2.15

Button {
    id: button
    property int w: 240
    width: window.width / 1280 * w
    height: window.width / 1280 * w / 8
    state: "enabled"
    states: [
        State {
            name: "active"
            when: button.enabled && typeof(blockRect) !== "undefined"
                  && ((type === "buttonLayers" && layerIndex === index)
                  || (typeof(dropdownIndex) !== "undefined" && index === dropdownIndex)
                      || (typeof(category) !== "undefined" && category === "history" && index === (actionsLog.count - 1) - stepIndex)
                      )
            PropertyChanges {
                target: button
                color: style.currentTheme.pinkWhite
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.lightDark
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "enabled"
            when: !(area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.darkGlass
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.pinkWhiteAccent
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.darkGlassDim
                radius: width / 24
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.pinkWhite
                font.pixelSize: button.height / 30 * 12
            }
        },
        State {
            name: "hovered"
            when: (area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: style.currentTheme.darkGlassAccent
                radius: width / 4
            }
            PropertyChanges {
                target: buttonText
                color: style.currentTheme.pinkWhiteAccent
                font.pixelSize: button.height / 30 * 12
            }
        }
    ]
    StyleSheet {id: style}
}
