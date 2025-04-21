import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: folder
    property string text: ""
    property int w: 240
    readonly property var pathes: {
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
    state: "down"
    width: window.width / 1280 * w
    height: window.width / 1280 * w / 8
    Item {
        x: parent.width * 0.05
        width: foldButton.x - x
        Label {
            text: folder.text
        }
    }
    ButtonWhite {
        id: foldButton
        image: triangle
        x: parent.width * 0.95 - width
        w: 40
        anchors.verticalCenter: parent.verticalCenter
        function clickAction() {
            const foldState = getFoldState()
            if (foldState === "collapsed") {
                setFoldState("default")
                folder.state = "down"
            } else {
                setFoldState("collapsed")
                folder.state = "right"
            }
        }
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
                fillColor: style.lightDark
                startX: pathes[folder.state][0].x; startY: pathes[folder.state][0].y
                Behavior on startX {
                    NumberAnimation { duration: animationDuration }
                }
                Behavior on startY {
                    NumberAnimation { duration: animationDuration }
                }
                PathLine {
                    x: pathes[folder.state][1].x
                    y: pathes[folder.state][1].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[folder.state][2].x
                    y: pathes[folder.state][2].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[folder.state][3].x
                    y: pathes[folder.state][3].y
                    Behavior on x {
                        NumberAnimation { duration: animationDuration }
                    }
                    Behavior on y {
                        NumberAnimation { duration: animationDuration }
                    }
                }
                PathLine {
                    x: pathes[folder.state][4].x
                    y: pathes[folder.state][4].y
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
