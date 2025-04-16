import QtQuick 2.15

Rectangle {
    id: spacer
    property var upperBlock
    property var lowerBlock
    property string type: "vertical"
    width: type === "horizontal" ?  5 : parent.width
    height: type === "horizontal" ? parent.height : 5
    color: spacerArea.containsMouse ? style.pinkWhiteAccent : style.pinkWhite //`#33${style.pinkWhiteDim.toString().substring(1)}`
    MouseArea {
        id: spacerArea
        anchors.fill: parent
        cursorShape: type === "horizontal" ?  Qt.SplitHCursor : Qt.SplitVCursor
        drag.axis: type === "horizontal" ? Drag.XAxis : Drag.YAxis
        drag.target: spacer
        drag.minimumY: spacer.parent.height * 0.15
        drag.maximumY: spacer.parent.height * 0.85
        drag.minimumX: spacer.parent.width * 0.2
        drag.maximumX: spacer.parent.width * 0.8
        hoverEnabled: true
        onMouseYChanged: if (containsPress && type === "vertical") resizeBlocksV()
        onMouseXChanged: if (containsPress && type === "horizontal") resizeBlocksH()
    }
    Behavior on color {
        ColorAnimation {
            target: spacer
            duration: 200
        }
    }

    function resizeBlocksV() {
        if (typeof(upperBlock) !== "undefined") {
            upperBlock.height = Qt.binding(() => spacer.y - height / 2)
            // upperBlock.y = 0
        }
        if (typeof(lowerBlock) !== "undefined") {
            lowerBlock.y = Qt.binding(() => spacer.y + height / 2)
            lowerBlock.height = Qt.binding(() => parent.height - lowerBlock.y)
        }
    }
    function resizeBlocksH() {
        if (typeof(upperBlock) !== "undefined") {
            upperBlock.width = Qt.binding(() => spacer.x - width / 2)
            // upperBlock.x = 0
        }
        if (typeof(lowerBlock) !== "undefined") {
            lowerBlock.x = Qt.binding(() => spacer.x + width / 2)
            lowerBlock.width = Qt.binding(() => parent.width - lowerBlock.x)
        }
    }
    function spacerReset() {
        if (typeof(upperBlock) !== "undefined") {
            upperBlock.x = 0
            upperBlock.y = 0
            upperBlock.width = 0
            upperBlock.height = 0
        }
        if (typeof(lowerBlock) !== "undefined") {
            lowerBlock.x = 0
            lowerBlock.y = 0
            lowerBlock.width = 0
            lowerBlock.height = 0
        }
    }

    StyleSheet {
        id: style
    }
}
