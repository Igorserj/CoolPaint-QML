import QtQuick 2.15

Scroller {
    id: scrollbar
    contentSize: parent.width
    width: parent.width
    height: window.width / 1280 * w
    states: [
        State {
            name: "disabled"
            when: !scrollbar.enabled || !bar.visible
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhiteDim
                radius: height / 3
            }
            PropertyChanges {
                target: contentItem
                x: baseVal
            }
        },
        State {
            name: "enabled"
            when: !scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhite
                radius: bar.height / 3
            }
        },
        State {
            name: "hovered"
            when: scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.currentTheme.pinkWhiteAccent
                radius: bar.height / 2
            }
        }
    ]
    StyleSheet {id: style}
    function wheelScroll(angleDeltaX, angleDeltaY) {
        wheelScrollX(angleDeltaX)
    }
    function scrolling(mouseX, mouseY) {
        scrollingX(mouseX)
    }
    function moveContent() {
        moveContentX()
    }
    function resetPosition() {
        resetPositionX()
    }
    function sizeChange() {
        widthChange()
    }
    function barProperties() {
        barPropertiesH()
    }
}
