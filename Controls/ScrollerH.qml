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
                color: window.style.currentTheme.pinkWhiteDim
                radius: strictStyle ? 0 : height / 3
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
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : bar.height / 3
            }
        },
        State {
            name: "hovered"
            when: scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: window.style.currentTheme.pinkWhiteAccent
                radius: strictStyle ? 0 : bar.height / 2
            }
        }
    ]

    function wheelScroll(angleDeltaX, angleDeltaY) {
        wheelScrollX(angleDeltaX)
    }
    function scrolling(mouseX, mouseY) {
        scrollingX(mouseX)
    }
    function moveContent() {
        moveContentX()
    }
    function sizeChange() {
        widthChange()
    }
    function barProperties() {
        barPropertiesH()
    }
}
