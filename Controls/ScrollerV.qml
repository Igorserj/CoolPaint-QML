import QtQuick 2.15

Scroller {
    id: scrollbar
    contentSize: parent.height
    height: parent.height
    width: window.width / 1280 * w
    states: [
        State {
            name: "disabled"
            when: !scrollbar.enabled || !bar.visible
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhiteDim
                radius: width / 3
            }
            PropertyChanges {
                target: contentItem
                y: baseVal
            }
        },
        State {
            name: "enabled"
            when: !scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhite
                radius: bar.width / 3
            }
        },
        State {
            name: "hovered"
            when: scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhiteAccent
                radius: bar.width / 2
            }
        }
    ]
    StyleSheet {id: style}
    function wheelScroll(angleDeltaX, angleDeltaY) {
        wheelScrollY(angleDeltaY)
    }
    function scrolling(mouseX, mouseY) {
        scrollingY(mouseY)
    }
    function moveContent() {
        moveContentY()
    }
    function resetPosition() {
        resetPositionY()
    }
    function sizeChange() {
        heightChange()
    }
    function barProperties() {
        barPropertiesV()
    }
}
