import QtQuick 2.15

Rectangle {
    property double contentSize: 0
    property double baseVal: 0
    property var contentItem
    property int w: 7
    property double scaling: 1.
    property alias bar: bar
    property alias scrollerArea: scrollerArea
    color: "transparent"
    state: "enabled"
    Rectangle {
        id: bar
        Component.onCompleted: {
            barProperties()
        }
        onYChanged: {
            moveContent()
        }
        onXChanged: {
            moveContent()
        }
        onHeightChanged: {
            sizeChange()
        }
        onWidthChanged: {
            sizeChange()
        }
        Behavior on y {
            PropertyAnimation {
                target: bar
                property: "y"
                duration: 50
            }
        }
        Behavior on x {
            PropertyAnimation {
                target: bar
                property: "x"
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
        onMouseYChanged: if (containsPress) scrolling(mouseX, mouseY)
        onMouseXChanged: if (containsPress) scrolling(mouseX, mouseY)
        onWheel: {
            wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
        }
    }

    function wheelScrollY(y) {
        scrollingY(-y/6 + (bar.y + bar.height / 2))
    }
    function wheelScrollX(x) {
        scrollingX(-x/6 + (bar.x + bar.width / 2))
    }

    function scrollingY(y) {
        if (bar.visible) {
            let pos
            if (y - bar.height / 2 < 0) {
                pos = 0
            } else if (y + bar.height / 2 > height) {
                pos = height - bar.height
            } else {
                pos = y - bar.height / 2
            }
            bar.y = pos
        }
    }
    function scrollingX(x) {
        if (bar.visible) {
            let pos
            if (x - bar.width / 2 < 0) {
                pos = 0
            } else if (x + bar.width / 2 > width) {
                pos = width - bar.width
            } else {
                pos = x - bar.width / 2
            }
            bar.x = pos
        }
    }

    function moveContentY() {
        contentItem.y = Qt.binding(() => (-contentSize * (1 - height / contentSize) / (height * (1 - height / contentSize) / bar.y)) + ((1 - 1 / scaling) * (contentSize / 2)))
    }
    function moveContentX() {
        contentItem.x = Qt.binding(() => (-contentSize * (1 - width / contentSize) / (width * (1 - width / contentSize) / bar.x)) + ((1 - 1 / scaling) * (contentSize / 2)))
    }

    function resetPositionY() {
        contentItem.y = 0
    }
    function resetPositionX() {
        contentItem.x = 0
    }
    function heightChange() {
        if (scaling > 1 && visible) {
            if (y + height > parent.height) {
                y = parent.height - height
            } else if (y < 0) {
                y = 0
            }
        }
    }
    function widthChange() {
        if (scaling > 1 && visible) {
            if (x + width > parent.width) {
                x = parent.width - width
            } else if (x < 0) {
                x = 0
            }
        }
    }
    function barPropertiesV() {
        bar.width = Qt.binding(() => w)
        bar.height = Qt.binding(() => height * height / contentSize)
        bar.visible = Qt.binding(() => contentSize > height)
        bar.y = Qt.binding(() => scaling > 1 ? (height - height * height / contentSize) / 2 : 0)
    }
    function barPropertiesH() {
        bar.height = Qt.binding(() => w)
        bar.width = Qt.binding(() => width * width / contentSize)
        bar.visible = Qt.binding(() => contentSize > width)
        bar.x = Qt.binding(() => scaling > 1 ? (width - width * width / contentSize) / 2 : 0)
    }
}
