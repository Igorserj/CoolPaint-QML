import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    property string shapeState: typeof(type) !== "undefined" ? type : ""
    property alias mover: mover
    property alias triangle: triangle
    property alias boxArrow: boxArrow
    property alias open: open
    property alias openProj: openProj
    property alias saveAs: saveAs
    property alias save: save
    property alias exportImg: exportImg
    property alias newProj: newProj
    property alias home: home
    property real scaleFactor: Math.min(parent.width, parent.height) / 10

    readonly property var arrowsPathes: {
        "enabled": [
                    { x: 4, y: 4.5 },
                    { x: 6, y: 4.5 },
                    { x: 5, y: 2.5 },
                    { x: 4, y: 4.5 },

                    { x: 4, y: 5.5 },
                    { x: 6, y: 5.5 },
                    { x: 5, y: 7.5 },
                    { x: 4, y: 5.5 }
                ],
        "layerSwap": [
                    { x: 4.5, y: 5.5 },
                    { x: 4.5, y: 3.5 },
                    { x: 2.5, y: 4.5 },
                    { x: 4.5, y: 5.5 },

                    { x: 5.5, y: 5.5 },
                    { x: 5.5, y: 3.5 },
                    { x: 7.5, y: 4.5 },
                    { x: 5.5, y: 5.5 }
                ]
    }
    readonly property var trianglePathes: {
        "down": [
                    { x: 5, y: 3 },
                    { x: 7, y: 3 },
                    { x: 5, y: 7 },
                    { x: 3, y: 3 }
                ],
        "right": [
                    { x: 3, y: 7 },
                    { x: 3, y: 3 },
                    { x: 7, y: 5 },
                    { x: 3, y: 7 }
                ]
    }
    readonly property var boxArrowPathes: [
        { x: 2, y: 3.5 },
        { x: 5, y: 3.5 },
        { x: 5, y: 6.5 },
        { x: 2, y: 6.5 },
        { x: 2, y: 3.5 },

        { x: 3.5, y: 5 },
        { x: 8.5, y: 5 },
        { x: 8.5, y: 5 },

        { x: 6, y: 3 },

        { x: 8.5, y: 5 },
        { x: 6, y: 7 }
    ]

    readonly property var openPathes: {
        "default": [
                    { x: 7, y: 2 },
                    { x: 3, y: 2 },
                    { x: 3, y: 7 },
                    { x: 4, y: 7 }, //3

                    { x: 7, y: 2 },
                    { x: 4, y: 2.5 }, //5
                    { x: 4, y: 7.5 }, //6
                    { x: 5, y: 7 }, //7

                    { x: 7, y: 2 },
                    { x: 5, y: 3 }, //9
                    { x: 5, y: 8 }, //10
                    { x: 7, y: 7 }, //11
                    { x: 7, y: 2 }
                ],
        "hovered": [
                    { x: 7, y: 2 },
                    { x: 3, y: 2 },
                    { x: 3, y: 7 },
                    { x: 3, y: 7 },

                    { x: 7, y: 2 },
                    { x: 3, y: 2 },
                    { x: 3, y: 7 },
                    { x: 7, y: 7 },

                    { x: 7, y: 2 },
                    { x: 7, y: 4 },
                    { x: 7, y: 9 },
                    { x: 7, y: 8 },
                    { x: 7, y: 2 }
                ]
    }

    readonly property var openProjPathes: {
        "default": [
                    { x: 3 , y: 6.5 },
                    { x: 7, y: 6.5 },
                    { x: 8, y: 4.5 },
                    { x: 4, y: 4.5 },
                    { x: 3, y: 6.5 },
                    { x: 3, y: 3 },
                    { x: 5, y: 3 },
                    { x: 5, y: 3.5 },
                    { x: 7, y: 3.5 },
                    { x: 7, y: 4.5 }
                ],
        "hovered": [
                    { x: 3, y: 6.5 },
                    { x: 7, y: 6.5 },
                    { x: 7, y: 3.5 },
                    { x: 3, y: 3.5 },
                    { x: 3, y: 6.5 },
                    { x: 3, y: 3 },
                    { x: 5, y: 3 },
                    { x: 5, y: 3.5 },
                    { x: 7, y: 3.5 },
                    { x: 7, y: 4.5 }
                ]
    }

    readonly property var saveAsPathes: {
        "default": [
                    { x: 4.5, y: 6.4 },
                    { x: 5, y: 7.9 },
                    { x: 5.5, y: 6.4 },
                    { x: 4.5, y: 6.4 },
                    { x: 4.5, y: 1.4 },
                    { x: 5.5, y: 1.4 },
                    { x: 5.5, y: 6.4 },

                    { x: 2, y: 8 },
                    { x: 5, y: 8.5 },
                    { x: 5, y: 8 }
                ],
        "hovered": [
                    { x: 5.9, y: 6.2 },
                    { x: 7.3, y: 6.7 },
                    { x: 6.6, y: 5.3 },
                    { x: 5.9, y: 6.2 },
                    { x: 2.3, y: 2.7 },
                    { x: 3.1, y: 2 },
                    { x: 6.6, y: 5.3 },

                    { x: 2, y: 8 },
                    { x: 5, y: 8.5 },
                    { x: 5, y: 8 }
                ]
    }

    readonly property var exportImgPathes: {
        "default": [
                    { x: 2, y: 4.5 },
                    { x: 2, y: 7.5 },
                    { x: 6, y: 7.5 },
                    { x: 6, y: 2.5 },
                    { x: 4, y: 2.5 },
                    { x: 2, y: 4.5 },

                    { x: 4, y: 4.5 },
                    { x: 4, y: 2.5 },

                    { x: 4, y: 5 },
                    { x: 8, y: 5 },
                    { x: 7, y: 4 },

                    { x: 8, y: 5 },
                    { x: 7, y: 6 }
                ],
        "hovered": [
                    { x: 1.5, y: 5 }, //0 xy
                    { x: 1.5, y: 7.5 }, //1 x
                    { x: 5.5, y: 7.5 }, //2 x
                    { x: 5.5, y: 2.5 }, //3 x
                    { x: 4, y: 2.5 },
                    { x: 1.5, y: 5 }, //5 xy

                    { x: 4, y: 5 }, //6 y
                    { x: 4, y: 2.5 },

                    { x: 4.5, y: 5 }, //8 x
                    { x: 8.5, y: 5 }, //9 x
                    { x: 7.5, y: 4 }, //10 x

                    { x: 8.5, y: 5 }, //11 x
                    { x: 7.5, y: 6 } //12 x
                ]
    }
    readonly property var newProjPathes: {
        "default": [
                    { x: 7, y: 4.5 },
                    { x: 7, y: 7.5 },
                    { x: 3, y: 7.5 },
                    { x: 3, y: 2.5 },
                    { x: 5, y: 2.5 },
                    { x: 6, y: 3.5 },
                    { x: 7, y: 4.5 },
                    { x: 5, y: 4.5 },
                    { x: 5, y: 2.5 }
                ],
        "hovered": [
                    { x: 7, y: 4.5 },
                    { x: 7, y: 7.5 },
                    { x: 3, y: 7.5 },
                    { x: 3, y: 2.5 },
                    { x: 5, y: 2.5 },
                    { x: 7, y: 2.5 },
                    { x: 7, y: 4.5 },
                    { x: 7, y: 2.5 },
                    { x: 7, y: 2.5 }
                ]
    }
    readonly property var homePathes: {
        "default": [
                    { x: 4.25, y: 7.5 },
                    { x: 3, y: 7.5 },
                    { x: 3, y: 4.5 },
                    { x: 2, y: 4.5 },
                    { x: 4, y: 2.5 },
                    { x: 6, y: 2.5 },
                    { x: 8, y: 4.5 },
                    { x: 7, y: 4.5 },
                    { x: 7, y: 7.5 },
                    { x: 5.75, y: 7.5 },
                    { x: 5.75, y: 5.5 },
                    { x: 4.25, y: 5.5 },
                    { x: 4.25, y: 7.5 },

                    { x: 5.75, y: 7.5 },
                    { x: 5.75, y: 5.5 },
                    { x: 4.25, y: 5.5 }
                ],
        "hovered": [
                    { x: 4.25, y: 7.5 },
                    { x: 3, y: 7.5 },
                    { x: 3, y: 4.5 },
                    { x: 2, y: 4.5 },
                    { x: 4, y: 2.5 },
                    { x: 6, y: 2.5 },
                    { x: 8, y: 4.5 },
                    { x: 7, y: 4.5 },
                    { x: 7, y: 7.5 },
                    { x: 5.75, y: 7.5 },
                    { x: 5.75, y: 5.5 },
                    { x: 4.25, y: 5.5 },
                    { x: 4.25, y: 7.5 },

                    { x: 5, y: 8 },
                    { x: 5, y: 6 },
                    { x: 4.25, y: 5.5 }
                ]
    }
// M 30 75 v -30 h -10 l 20 -20 h 20 l 20 20 h -10 v 30 h -12.5 v -20 h -15 v 20 h -12.5 M 42.5 75 l 15 0 v -20 l -15 0
    Component {
        id: triangle
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "transparent"
                capStyle: ShapePath.RoundCap
                fillColor: window.style.currentTheme.lightDark
                startX: trianglePathes[shapeState][0].x * scaleFactor
                startY: trianglePathes[shapeState][0].y * scaleFactor
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: trianglePathes[shapeState][1].x * scaleFactor
                    y: trianglePathes[shapeState][1].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: trianglePathes[shapeState][2].x * scaleFactor
                    y: trianglePathes[shapeState][2].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: trianglePathes[shapeState][3].x * scaleFactor
                    y: trianglePathes[shapeState][3].y * scaleFactor
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
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "transparent"
                capStyle: ShapePath.RoundCap
                fillColor: window.style.currentTheme.lightDark
                startX: arrowsPathes[shapeState][0].x * scaleFactor
                startY: arrowsPathes[shapeState][0].y * scaleFactor
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: arrowsPathes[shapeState][1].x * scaleFactor
                    y: arrowsPathes[shapeState][1].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][2].x * scaleFactor
                    y: arrowsPathes[shapeState][2].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][3].x * scaleFactor
                    y: arrowsPathes[shapeState][3].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: arrowsPathes[shapeState][4].x * scaleFactor
                    y: arrowsPathes[shapeState][4].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][5].x * scaleFactor
                    y: arrowsPathes[shapeState][5].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][6].x * scaleFactor
                    y: arrowsPathes[shapeState][6].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: arrowsPathes[shapeState][7].x * scaleFactor
                    y: arrowsPathes[shapeState][7].y * scaleFactor
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
        id: boxArrow
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.pinkWhiteAccent
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.5 * scaleFactor
                fillColor: "transparent"
                startX: boxArrowPathes[0].x * scaleFactor
                startY: boxArrowPathes[0].y * scaleFactor
                PathLine {
                    x: boxArrowPathes[1].x * scaleFactor
                    y: boxArrowPathes[1].y * scaleFactor
                }
                PathLine {
                    x: boxArrowPathes[2].x * scaleFactor
                    y: boxArrowPathes[2].y * scaleFactor
                }
                PathLine {
                    x: boxArrowPathes[3].x * scaleFactor
                    y: boxArrowPathes[3].y * scaleFactor
                }
                PathLine {
                    x: boxArrowPathes[4].x * scaleFactor
                    y: boxArrowPathes[4].y * scaleFactor
                }

                PathMove {
                    x: boxArrowPathes[5].x * scaleFactor
                    y: boxArrowPathes[5].y * scaleFactor
                }
                PathLine {
                    x: boxArrowPathes[6].x * scaleFactor
                    y: boxArrowPathes[6].y * scaleFactor
                }
                PathMove {
                    x: boxArrowPathes[7].x * scaleFactor
                    y: boxArrowPathes[7].y * scaleFactor
                }

                PathLine {
                    x: boxArrowPathes[8].x * scaleFactor
                    y: boxArrowPathes[8].y * scaleFactor
                }

                PathMove {
                    x: boxArrowPathes[9].x * scaleFactor
                    y: boxArrowPathes[9].y * scaleFactor
                }
                PathLine {
                    x: boxArrowPathes[10].x * scaleFactor
                    y: boxArrowPathes[10].y * scaleFactor
                }
            }
        }
    }

    Component {
        id: open
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: openPathes[shapeState][0].x * scaleFactor
                startY: openPathes[shapeState][0].y * scaleFactor
                PathLine {
                    x: openPathes[shapeState][1].x * scaleFactor
                    y: openPathes[shapeState][1].y * scaleFactor
                }
                PathLine {
                    x: openPathes[shapeState][2].x * scaleFactor
                    y: openPathes[shapeState][2].y * scaleFactor
                }
                PathLine {
                    x: openPathes[shapeState][3].x * scaleFactor
                    y: openPathes[shapeState][3].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: openPathes[shapeState][4].x * scaleFactor
                    y: openPathes[shapeState][4].y * scaleFactor
                }
                PathLine {
                    x: openPathes[shapeState][5].x * scaleFactor
                    y: openPathes[shapeState][5].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openPathes[shapeState][6].x * scaleFactor
                    y: openPathes[shapeState][6].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openPathes[shapeState][7].x * scaleFactor
                    y: openPathes[shapeState][7].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: openPathes[shapeState][8].x * scaleFactor
                    y: openPathes[shapeState][8].y * scaleFactor
                }
                PathLine {
                    x: openPathes[shapeState][9].x * scaleFactor
                    y: openPathes[shapeState][9].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openPathes[shapeState][10].x * scaleFactor
                    y: openPathes[shapeState][10].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openPathes[shapeState][11].x * scaleFactor
                    y: openPathes[shapeState][11].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openPathes[shapeState][12].x * scaleFactor
                    y: openPathes[shapeState][12].y * scaleFactor
                }
            }
        }
    }

    Component {
        id: openProj
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: openProjPathes[shapeState][0].x * scaleFactor
                startY: openProjPathes[shapeState][0].y * scaleFactor
                PathLine {
                    x: openProjPathes[shapeState][1].x * scaleFactor
                    y: openProjPathes[shapeState][1].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][2].x * scaleFactor
                    y: openProjPathes[shapeState][2].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openProjPathes[shapeState][3].x * scaleFactor
                    y: openProjPathes[shapeState][3].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: openProjPathes[shapeState][4].x * scaleFactor
                    y: openProjPathes[shapeState][4].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][5].x * scaleFactor
                    y: openProjPathes[shapeState][5].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][6].x * scaleFactor
                    y: openProjPathes[shapeState][6].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][7].x * scaleFactor
                    y: openProjPathes[shapeState][7].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][8].x * scaleFactor
                    y: openProjPathes[shapeState][8].y * scaleFactor
                }
                PathLine {
                    x: openProjPathes[shapeState][9].x * scaleFactor
                    y: openProjPathes[shapeState][9].y * scaleFactor
                }
            }
        }
    }

    Component {
        id: save
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: 2 * scaleFactor
                startY: 7 * scaleFactor
                PathLine {
                    x: 3 * scaleFactor
                    y: 7 * scaleFactor
                }
                PathLine {
                    x: 2.5 * scaleFactor
                    y: 8.5 * scaleFactor
                }
                PathLine {
                    x: 2 * scaleFactor
                    y: 7 * scaleFactor
                }
                PathLine {
                    x: 2 * scaleFactor
                    y: 2 * scaleFactor
                }
                PathLine {
                    x: 3 * scaleFactor
                    y: 2 * scaleFactor
                }
                PathLine {
                    x: 3 * scaleFactor
                    y: 7 * scaleFactor
                }

                PathMove {
                    x: 6 * scaleFactor
                    y: 6.5 * scaleFactor
                }
                PathLine {
                    x: 8 * scaleFactor
                    y: 6.5 * scaleFactor
                }
                PathLine {
                    x: 8 * scaleFactor
                    y: 7 * scaleFactor
                }
                PathLine {
                    x: 6 * scaleFactor
                    y: 7 * scaleFactor
                }
                PathLine {
                    x: 6 * scaleFactor
                    y: 3 * scaleFactor
                }
                PathLine {
                    x: 8 * scaleFactor
                    y: 3 * scaleFactor
                }
                PathLine {
                    x: 8 * scaleFactor
                    y: 6.5 * scaleFactor
                }
            }
        }
    }

    Component {
        id: saveAs
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: saveAsPathes[shapeState][0].x * scaleFactor
                startY: saveAsPathes[shapeState][0].y * scaleFactor
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: saveAsPathes[shapeState][1].x * scaleFactor
                    y: saveAsPathes[shapeState][1].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: saveAsPathes[shapeState][2].x * scaleFactor
                    y: saveAsPathes[shapeState][2].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: saveAsPathes[shapeState][3].x * scaleFactor
                    y: saveAsPathes[shapeState][3].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: saveAsPathes[shapeState][4].x * scaleFactor
                    y: saveAsPathes[shapeState][4].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: saveAsPathes[shapeState][5].x * scaleFactor
                    y: saveAsPathes[shapeState][5].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: saveAsPathes[shapeState][6].x * scaleFactor
                    y: saveAsPathes[shapeState][6].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: saveAsPathes[shapeState][7].x * scaleFactor
                    y: saveAsPathes[shapeState][7].y * scaleFactor
                }
                PathLine {
                    x: saveAsPathes[shapeState][8].x * scaleFactor
                    y: saveAsPathes[shapeState][8].y * scaleFactor
                }
                PathLine {
                    x: saveAsPathes[shapeState][9].x * scaleFactor
                    y: saveAsPathes[shapeState][9].y * scaleFactor
                }
            }
        }
    }

    Component {
        id: exportImg
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: exportImgPathes[shapeState][0].x * scaleFactor
                startY: exportImgPathes[shapeState][0].y * scaleFactor
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: exportImgPathes[shapeState][1].x * scaleFactor
                    y: exportImgPathes[shapeState][1].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][2].x * scaleFactor
                    y: exportImgPathes[shapeState][2].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][3].x * scaleFactor
                    y: exportImgPathes[shapeState][3].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][4].x * scaleFactor
                    y: exportImgPathes[shapeState][4].y * scaleFactor
                }
                PathLine {
                    x: exportImgPathes[shapeState][5].x * scaleFactor
                    y: exportImgPathes[shapeState][5].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathLine {
                    x: exportImgPathes[shapeState][6].x * scaleFactor
                    y: exportImgPathes[shapeState][6].y * scaleFactor
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][7].x * scaleFactor
                    y: exportImgPathes[shapeState][7].y * scaleFactor
                }

                PathMove {
                    x: exportImgPathes[shapeState][8].x * scaleFactor
                    y: exportImgPathes[shapeState][8].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][9].x * scaleFactor
                    y: exportImgPathes[shapeState][9].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][10].x * scaleFactor
                    y: exportImgPathes[shapeState][10].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }

                PathMove {
                    x: exportImgPathes[shapeState][11].x * scaleFactor
                    y: exportImgPathes[shapeState][11].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: exportImgPathes[shapeState][12].x * scaleFactor
                    y: exportImgPathes[shapeState][12].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                }
            }
        }
    }

    Component {
        id: newProj
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: newProjPathes[shapeState][0].x * scaleFactor
                startY: newProjPathes[shapeState][0].y * scaleFactor
                PathLine {
                    x: newProjPathes[shapeState][1].x * scaleFactor
                    y: newProjPathes[shapeState][1].y * scaleFactor
                }
                PathLine {
                    x: newProjPathes[shapeState][2].x * scaleFactor
                    y: newProjPathes[shapeState][2].y * scaleFactor
                }
                PathLine {
                    x: newProjPathes[shapeState][3].x * scaleFactor
                    y: newProjPathes[shapeState][3].y * scaleFactor
                }
                PathLine {
                    x: newProjPathes[shapeState][4].x * scaleFactor
                    y: newProjPathes[shapeState][4].y * scaleFactor
                }
                PathLine {
                    x: newProjPathes[shapeState][5].x * scaleFactor
                    y: newProjPathes[shapeState][5].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: newProjPathes[shapeState][6].x * scaleFactor
                    y: newProjPathes[shapeState][6].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: newProjPathes[shapeState][7].x * scaleFactor
                    y: newProjPathes[shapeState][7].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: newProjPathes[shapeState][8].x * scaleFactor
                    y: newProjPathes[shapeState][8].y * scaleFactor
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
        id: home
        Shape {
            readonly property int animationDuration: strictStyle ? 0 : 250
            width: 10 * scaleFactor
            height: 10 * scaleFactor
            anchors.centerIn: parent
            ShapePath {
                strokeColor: window.style.currentTheme.lightDark
                capStyle: ShapePath.RoundCap
                strokeWidth: 0.4 * scaleFactor
                joinStyle: ShapePath.RoundJoin
                fillColor: "transparent"
                startX: homePathes[shapeState][0].x * scaleFactor
                startY: homePathes[shapeState][0].y * scaleFactor
                PathLine {
                    x: homePathes[shapeState][1].x * scaleFactor
                    y: homePathes[shapeState][1].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][2].x * scaleFactor
                    y: homePathes[shapeState][2].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][3].x * scaleFactor
                    y: homePathes[shapeState][3].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][4].x * scaleFactor
                    y: homePathes[shapeState][4].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][5].x * scaleFactor
                    y: homePathes[shapeState][5].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][6].x * scaleFactor
                    y: homePathes[shapeState][6].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][7].x * scaleFactor
                    y: homePathes[shapeState][7].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][8].x * scaleFactor
                    y: homePathes[shapeState][8].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][9].x * scaleFactor
                    y: homePathes[shapeState][9].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][10].x * scaleFactor
                    y: homePathes[shapeState][10].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][11].x * scaleFactor
                    y: homePathes[shapeState][11].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][12].x * scaleFactor
                    y: homePathes[shapeState][12].y * scaleFactor
                }
                PathLine {
                    x: homePathes[shapeState][13].x * scaleFactor
                    y: homePathes[shapeState][13].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: homePathes[shapeState][14].x * scaleFactor
                    y: homePathes[shapeState][14].y * scaleFactor
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: homePathes[shapeState][15].x * scaleFactor
                    y: homePathes[shapeState][15].y * scaleFactor
                }
            }
        }
    }
}
