import QtQuick 2.15

Rectangle {
    id: blockRect
    property var blockModel: []
    property int index: -1
    property string type: ''
    property string name: ''
    color: "transparent"
    height: 0.5 * parent.height - window.height * 0.005
    width: parent.width
    clip: true
    state: "enabled"
    states: [
        State {
            name: "enabled"
        },
        State {
            name: "insertion"
        },
        State {
            name: "insertion2"
        },
        State {
            name: "layerSwap"
        }
    ]
    Rectangle {
        width: column.width * 0.95
        height: column.height
        anchors.horizontalCenter: column.horizontalCenter
        color: "#0AFFFFFF"
        radius: parent.width / 24
    }
    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: window.height * 0.005
        Repeater {
            id: rep
            model: blockModel
            delegate: Item {
                property bool blockIndex: index
                height: col.height
                width: window.width / 1280 * 260
                z: -index + blockModel.count
                MouseArea {
                    id: colArea
                    anchors.fill: col
                    onWheel: {
                        scroller.wheelScroll(wheel.angleDelta.y)
                    }
                }
                Column {
                    id: col
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: window.height * 0.005
                    Behavior on y {
                        NumberAnimation { duration: 250 }
                    }
                    Repeater {
                        model: block
                        delegate: Controls {
                            enabled: type === "header" || enableByState(type, name, isOverlay)
                            function controlsAction() {
                                clickAction(name, type, index)
                            }
                        }
                    }
                }
                Scroller {
                    id: scroller
                    enabled: index > 0
                    anchors.right: parent.right
                    height: blockRect.height - rep.itemAt(0).height - col.spacing
                    contentItem: col
                }
            }
        }
    }
    StyleSheet {id: style}
    function enableByState(type, name, isOverlay) {
        if (blockRect.enabled) {
            switch (blockRect.state) {
            case "enabled": return true
            case "insertion": return isOverlay
            case "insertion2": return name !== "Overlay"
            case "layerSwap": return true
            }
        }
        else return false
    }
    function clickAction(name, type, index) {
        blockRect.name = name
        blockRect.type = type
        blockRect.index = index
        blockAction(index)
    }
    // function blockAction(index) {}
}
