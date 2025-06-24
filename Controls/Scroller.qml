import QtQuick 2.15

Rectangle {
    property double contentSize: 0
    property double baseVal: 0
    property var contentItem
    property int w: 7
    property double scaling: -1.
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
                duration: strictStyle ? 0 : 25
            }
        }
        Behavior on x {
            PropertyAnimation {
                target: bar
                property: "x"
                duration: strictStyle ? 0 : 25
            }
        }
        Behavior on color {
            ColorAnimation {
                target: bar
                duration: strictStyle ? 0 : 200
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
        onMouseXChanged: if (pressed) draggingX(mouseX)
        onMouseYChanged: if (pressed) draggingY(mouseY)
        onWheel: {
            wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
        }
    }
    PropertyAction {
        id: barXAction
        property real pos: 0
        target: bar
        property: "x"
        value: pos
    }
    PropertyAction {
        id: barYAction
        property real pos: 0
        target: bar
        property: "y"
        value: pos
    }

    function wheelScrollY(y) {
        scrollingY(-y/6 + (bar.y + bar.height / 2))
    }
    function wheelScrollX(x) {
        scrollingX(-x/6 + (bar.x + bar.width / 2))
    }

    function scrollingY(dy) {
        if (bar.visible) {
            const unit = bar.height / 8
            let pos
            if (bar.y < dy - bar.height / 2) {
                pos = Math.min(height - bar.height, bar.y + unit)
            } else if (bar.y > dy - bar.height / 2) {
                pos = Math.max(0, bar.y - unit)
            }
            bar.y = pos
        }
    }
    function scrollingX(dx) {
        if (bar.visible) {
            const unit = bar.width / 8
            let pos
            if (bar.x < dx - bar.width / 2) {
                pos = Math.min(width - bar.width, bar.x + unit)
            } else if (bar.x > dx - bar.width / 2) {
                pos = Math.max(0, bar.x - unit)
            }
            bar.x = pos
        }
    }

    function draggingY(dy) {
        if (bar.visible) {
            let pos
            if (dy - bar.height / 2 < 0) {
                pos = 0
            } else if (dy + bar.height / 2 > height) {
                pos = height - bar.height
            } else {
                pos = dy - bar.height / 2
            }
            bar.y = pos
        }
    }
    function draggingX(dx) {
        if (bar.visible) {
            let pos
            if (dx - bar.width / 2 < 0) {
                pos = 0
            } else if (dx + bar.width / 2 > width) {
                pos = width - bar.width
            } else {
                pos = dx - bar.width / 2
            }
            bar.x = pos
        }
    }

    function moveContentY() {
        if (bar.visible) {
            if (scaling === -1) {
                contentItem.y = Qt.binding(() => (-contentSize * (1 - height / contentSize) / (height * (1 - height / contentSize) / bar.y)) + (0 * (contentSize / 2)))
            } else {
                contentItem.y = Qt.binding(() => (-contentSize * (1 - height / contentSize) / (height * (1 - height / contentSize) / bar.y)) + ((1 - 1 / scaling) * (contentSize / 2)))
            }
        }
    }
    function moveContentX() {
        if (bar.visible) {
            if (scaling === -1) {
                contentItem.x = Qt.binding(() => (-contentSize * (1 - width / contentSize) / (width * (1 - width / contentSize) / bar.x)) + (0 * (contentSize / 2)))
            } else {
                contentItem.x = Qt.binding(() => (-contentSize * (1 - width / contentSize) / (width * (1 - width / contentSize) / bar.x)) + ((1 - 1 / scaling) * (contentSize / 2)))
            }
        }
    }

    function heightChange() {
        y = Math.min(Math.max(y, 0), Math.abs(parent.height - height))
        scrollBarY()
    }
    function widthChange() {
        x = Math.min(Math.max(x, 0), Math.abs(parent.width - width))
        scrollBarX()
    }

    function scrollBarY() {
        let pos
        if (bar.y <= 0) {
            pos = 0
        } else if (bar.y + bar.height >= height) {
            pos = height - bar.height
        } else {
            pos = bar.y
        }
        barYAction.pos = pos
        barYAction.start()
    }

    function scrollBarX() {
        let pos
        if (bar.x <= 0) {
            pos = 0
        } else if (bar.x + bar.width >= width) {
            pos = width - bar.width
        } else {
            pos = bar.x
        }
        barXAction.pos = pos
        barXAction.start()
    }

    function barPropertiesV() {
        bar.width = Qt.binding(() => w)
        bar.height = Qt.binding(() => height * height / contentSize)
        bar.visible = Qt.binding(() => contentSize > height)
        if (scaling !== -1) bar.y = Qt.binding(() => scaling !== -1 && height < contentSize * scaling ? (height - height * height / contentSize) / 2 : 0)
    }
    function barPropertiesH() {
        bar.height = Qt.binding(() => w)
        bar.width = Qt.binding(() => width * width / contentSize)
        bar.visible = Qt.binding(() => contentSize > width)
        if (scaling !== -1) bar.x = Qt.binding(() => scaling !== -1 && width < contentSize * scaling ? (width - width * width / contentSize) / 2 : 0)
    }
}
