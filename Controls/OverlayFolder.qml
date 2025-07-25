import QtQuick 2.15

Item {
    id: folder
    property var folderAction
    property string text: ""
    property int w: 240
    property int elide: Text.ElideNone
    state: "down"
    width: biggerSide * w
    height: biggerSide * w / 8
    Item {
        x: parent.width * 0.05
        width: foldButton.x - x
        Label {
            id: label
            text: folder.text
            elide: folder.elide
        }
    }
    ButtonWhite {
        id: foldButton
        property string icon: "triangle"
        property string type: folder.state//"down"
        x: parent.width * 0.95 - width
        w: 40
        anchors.verticalCenter: parent.verticalCenter
        Component.onCompleted: folderAction = switchFold
        function clickAction() {
            switchFold()
        }
        function switchFold() {
            const foldState = getFoldState()
            if (foldState === "collapsed") {
                setFoldState("default")
                type = "down"
                folder.state = type
            } else {
                setFoldState("collapsed")
                type = "right"
                folder.state = type
            }
        }
    }
}
