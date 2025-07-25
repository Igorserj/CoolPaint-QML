import QtQuick 2.15

Scroller {
    id: scrollbar
    contentSize: parent.width
    width: parent.width
    height: biggerSide * w
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
            PropertyChanges {
                target: scrollerArea
                enabled: false
                hoverEnabled: false
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
            PropertyChanges {
                target: scrollerArea
                enabled: true
                hoverEnabled: true
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
            PropertyChanges {
                target: scrollerArea
                enabled: true
                hoverEnabled: true
            }
        }
    ]

    function wheelScroll(angleDeltaX, angleDeltaY) {
        wheelScrollX(angleDeltaX || angleDeltaY)
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
    function dragging(x, y) {
        const dx = -x/6 + (bar.x + bar.width / 2)
        draggingX(dx)
    }
}
