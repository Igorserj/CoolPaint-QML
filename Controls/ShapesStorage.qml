import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    property string shapeState: ""
    property alias mover: mover
    property alias triangle: triangle
    readonly property var arrowsPathes: {
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
    readonly property var trianglePathes: {
        "down": [
                    { x: 5, y: 0 },
                    { x: 10, y: 0 },
                    { x: 5, y: 10 },
                    { x: 0, y: 0 },
                    { x: 5, y: 0 }
                ],
        "right": [
                    { x: 0, y: 5 },
                    { x: 0, y: 0 },
                    { x: 10, y: 5 },
                    { x: 0, y: 10 },
                    { x: 0, y: 5 }
                ]
    }

    Component {
        id: triangle
        Shape {
            readonly property int animationDuration: 250
            width: 10
            height: 10
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "transparent"
                fillColor: style.currentTheme.lightDark
                startX: trianglePathes[shapeState][0].x; startY: trianglePathes[shapeState][0].y
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: trianglePathes[shapeState][1].x
                    y: trianglePathes[shapeState][1].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: trianglePathes[shapeState][2].x
                    y: trianglePathes[shapeState][2].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: trianglePathes[shapeState][3].x
                    y: trianglePathes[shapeState][3].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: trianglePathes[shapeState][4].x
                    y: trianglePathes[shapeState][4].y
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
    Component {
        id: mover
        Shape {
            readonly property int animationDuration: 250
            width: 12
            height: 12
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "transparent"
                fillColor: style.currentTheme.lightDark
                startX: arrowsPathes[shapeState][0].x; startY: arrowsPathes[shapeState][0].y
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: arrowsPathes[shapeState][1].x
                    y: arrowsPathes[shapeState][1].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][2].x
                    y: arrowsPathes[shapeState][2].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][3].x
                    y: arrowsPathes[shapeState][3].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: arrowsPathes[shapeState][4].x
                    y: arrowsPathes[shapeState][4].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][5].x
                    y: arrowsPathes[shapeState][5].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][6].x
                    y: arrowsPathes[shapeState][6].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][7].x
                    y: arrowsPathes[shapeState][7].y
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
