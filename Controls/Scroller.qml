import QtQuick 2.15

Rectangle {
    id: scrollbar
    property double contentHeight: parent.height
    property var contentItem
    property alias scrollerArea: scrollerArea
    property int w: 7
    height: parent.height
    width: window.width / 1280 * w
    color: "transparent"
    state: "enabled"
    states: [
        State {
            name: "enabled"
            when: !scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.pinkWhite
                radius: bar.width / 3
            }
        },
        State {
            name: "disabled"
            when: !scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.pinkWhiteDim
                radius: width / 3
            }
        },
        State {
            name: "hovered"
            when: scrollerArea.containsMouse && scrollbar.enabled
            PropertyChanges {
                target: bar
                color: style.pinkWhiteAccent
                radius: bar.width / 2
            }
        }
    ]
    Rectangle {
        id: bar
        visible: contentHeight > height
        height: parent.height * parent.height / contentHeight
        width: parent.width
        x: (parent.width - width) / 2
        onYChanged: {
            moveContent()
        }
        Behavior on y {
            PropertyAnimation {
                target: bar
                property: "y"
                duration: 50
            }
        }
        Behavior on color {
            ColorAnimation {
                target: bar
                duration: 200
            }
        }
        Behavior on radius {
            PropertyAnimation {
                target: bar
                property: "radius"
                duration: 200
            }
        }
    }
    MouseArea {
        id: scrollerArea
        anchors.fill: parent
        hoverEnabled: true
        onMouseYChanged: if (containsPress) scrolling(mouseY)
        onWheel: {
            wheelScroll(wheel.angleDelta.y)
        }
    }
    StyleSheet {id: style}

    function wheelScroll(y) {
        scrolling(-y/4 + (bar.y + bar.height / 2))
    }

    function scrolling(y) {
        if (bar.visible) bar.y = y - bar.height / 2 < 0 ? 0 : y + bar.height / 2 > height ? height - bar.height : y - bar.height / 2
    }

    function moveContent() {
        contentItem.y = -contentHeight * (1-height / contentHeight) / (height * (1-height / contentHeight) / bar.y)
    }
}
