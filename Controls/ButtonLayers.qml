import QtQuick 2.15
import QtQuick.Shapes 1.15

ButtonDark {
    property string swapState: blockRect.state === "layerSwap" && layerIndex === index ? "layerSwap" : "enabled"
    readonly property var pathes: {
        "enabled": [
                    { x: 6, y: 0 },
                    { x: 8.5, y: 5 },
                    { x: 3.5, y: 5 },
                    { x: 6, y: 0 },

                    { x: 6, y: 12 },
                    { x: 8.5, y: 7 },
                    { x: 3.5, y: 7 },
                    { x: 6, y: 12 }
                ],
        "layerSwap": [
                    { y: 6, x: 12 },
                    { y: 8.5, x: 7 },
                    { y: 3.5, x: 7 },
                    { y: 6, x: 12 },

                    { y: 6, x: 0 },
                    { y: 8.5, x: 5 },
                    { y: 3.5, x: 5 },
                    { y: 6, x: 0 }
                ]
    }
    ButtonWhite {
        w: parent.w / 6
        x: (parent.width - width) - (parent.width / 24)
        y: (parent.height - height) / 2
        text: "⨯"
        function clickAction() {
            removeLayer(index)
            if (!doNotLog.includes(category)) autoSave()
        }
    }
    ButtonWhite {
        w: parent.w / 6
        x: (parent.width / 24)
        y: (parent.height - height) / 2
        image: mover
        function clickAction() {
            if (blockRect.state !== "layerSwap") {
                layerIndex = index
                blockRect.state = "layerSwap"
            }
            else blockRect.state = "enabled"
        }
    }

    Component {
        id: mover
        Shape {
            readonly property int animationDuration: 250
            width: 12
            height: 12
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "transparent"
                fillColor: style.lightDark
                startX: pathes[blockRect.state][0].x; startY: pathes[blockRect.state][0].y
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: pathes[blockRect.state][1].x
                    y: pathes[blockRect.state][1].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[blockRect.state][2].x
                    y: pathes[blockRect.state][2].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[blockRect.state][3].x
                    y: pathes[blockRect.state][3].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: pathes[blockRect.state][4].x
                    y: pathes[blockRect.state][4].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[blockRect.state][5].x
                    y: pathes[blockRect.state][5].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[blockRect.state][6].x
                    y: pathes[blockRect.state][6].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[blockRect.state][7].x
                    y: pathes[blockRect.state][7].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
            }
        }
    }
}
