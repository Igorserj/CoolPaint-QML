import QtQuick 2.15

Item {
    id: folder
    property string text: ""
    property int w: 240
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
        image: shapes.triangle
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
    ShapesStorage {
        id: shapes
        shapeState: folder.state
    }
}
