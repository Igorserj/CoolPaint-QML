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
// Rectangle {
//     height: parent.height
//     width: window.width / 1280 * w
//     color: "transparent"
//     state: "enabled"
//     states: [
//         State {
//             name: "disabled"
//             when: !scrollbar.enabled || !bar.visible
//             PropertyChanges {
//                 target: bar
//                 color: style.currentTheme.pinkWhiteDim
//                 radius: width / 3
//             }
//             PropertyChanges {
//                 target: contentItem
//                 y: 0
//             }
//         },
//         State {
//             name: "enabled"
//             when: !scrollerArea.containsMouse && scrollbar.enabled
//             PropertyChanges {
//                 target: bar
//                 color: style.currentTheme.pinkWhite
//                 radius: bar.width / 3
//             }
//         },
//         State {
//             name: "hovered"
//             when: scrollerArea.containsMouse && scrollbar.enabled
//             PropertyChanges {
//                 target: bar
//                 color: style.currentTheme.pinkWhiteAccent
//                 radius: bar.width / 2
//             }
//         }
//     ]
//     Rectangle {
//         id: bar
//         visible: contentSize > height
//         height: parent.height * parent.height / contentSize
//         width: parent.width
//         x: (parent.width - width) / 2
//         y: scaling > 1 ? (parent.height  - height) / 2 : 0
//         onYChanged: {
//             moveContent()
//         }
//         onHeightChanged: {
//             if (scaling > 1 && visible) {
//                 if (y + height > parent.height) {
//                     y = parent.height - height
//                 } else if (y < 0) {
//                     y = 0
//                 }
//             }
//         }
//         Behavior on y {
//             PropertyAnimation {
//                 target: bar
//                 property: "y"
//                 duration: 50
//             }
//         }
//         Behavior on color {
//             ColorAnimation {
//                 target: bar
//                 duration: 200
//             }
//         }
//         Behavior on radius {
//             PropertyAnimation {
//                 target: bar
//                 property: "radius"
//                 duration: 200
//             }
//         }
//     }
//     MouseArea {
//         id: scrollerArea
//         anchors.fill: parent
//         hoverEnabled: true
//         onMouseYChanged: if (containsPress) scrolling(mouseY)
//         onWheel: {
//             wheelScroll(wheel.angleDelta.y)
//         }
//     }
//     StyleSheet {id: style}

//     function wheelScroll(y) {
//         scrolling(-y/6 + (bar.y + bar.height / 2))
//     }
//     function scrolling(y) {
//         if (bar.visible) {
//             console.log(y)
//             let pos
//             if (y - bar.height / 2 < 0) {
//                 pos = 0
//             } else if (y + bar.height / 2 > height) {
//                 pos = height - bar.height
//             } else {
//                 pos = y - bar.height / 2
//             }
//             bar.y = pos
//         }
//     }
//     function moveContent() {
//         contentItem.y = Qt.binding(() => (-contentSize * (1 - height / contentSize) / (height * (1 - height / contentSize) / bar.y)) + ((1 - 1 / scaling) * (contentSize / 2)))
//     }
//     function resetPosition() {
//         contentItem.y = 0
//     }
// }
