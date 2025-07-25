import QtQuick 2.15

Button {
    id: button
    property int w: 240
    width: biggerSide * w
    height: biggerSide * w / 8
    state: "enabled"
    states: [
        State {
            name: "active"
            when: button.enabled && typeof(blockRect) !== "undefined"
                  && ((type === "buttonLayers" && layerIndex === idx/*index*/)
                  || (typeof(dropdownIndex) !== "undefined" && index === dropdownIndex)
                      || (typeof(category) !== "undefined" && category === "history" && index === (actionsLog.count - 1) - stepIndex)
                      )
            PropertyChanges {
                target: button
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : width / 4
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.lightDark
                font.pixelSize: biggerSide * w / 8 / 30 * 12
            }
        },
        State {
            name: "enabled"
            when: !(area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.darkGlass
                radius: strictStyle ? 0 : width / 24
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.pinkWhiteAccent
                font.pixelSize: biggerSide * w / 8 / 30 * 12
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
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.pinkWhite
                font.pixelSize: biggerSide * w / 8 / 30 * 12
            }
        },
        State {
            name: "hovered"
            when: (area.containsMouse || label.containsMouse) && button.enabled
            PropertyChanges {
                target: button
                color: window.style.currentTheme.darkGlassAccent
                radius: strictStyle ? 0 : width / 4
            }
            PropertyChanges {
                target: buttonText
                color: window.style.currentTheme.pinkWhiteAccent
                font.pixelSize: biggerSide * w / 8 / 30 * 12
            }
        }
    ]
}
