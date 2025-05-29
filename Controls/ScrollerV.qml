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
                color: window.style.currentTheme.pinkWhiteDim
                radius: strictStyle ? 0 : width / 3
            }
            PropertyChanges {
                target: contentItem
                y: baseVal// < 0 ? 0 : baseVal > scrollbar.height - contentSize ? scrollbar.height - contentSize : baseVal
            }
        },
        State {
            name: "enabled"
            when: !scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : bar.width / 3
            }
        },
        State {
            name: "hovered"
            when: scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: window.style.currentTheme.pinkWhiteAccent
                radius: strictStyle ? 0 : bar.width / 2
            }
        }
    ]

    function wheelScroll(angleDeltaX, angleDeltaY) {
        wheelScrollY(angleDeltaY)
    }
    function scrolling(mouseX, mouseY) {
        scrollingY(mouseY)
    }
    function moveContent() {
        moveContentY()
    }
    function sizeChange() {
        heightChange()
    }
    function barProperties() {
        barPropertiesV()
    }
}
