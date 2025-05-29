import QtQuick 2.15

Rectangle {
    id: blockRect
    property var blockModel: []
    property int index: -1
    property string type: ''
    property string name: ''
    property var val: []
    color: "transparent"
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
        height: column.height + window.height * 0.01
        anchors.horizontalCenter: column.horizontalCenter
        color: window.style.currentTheme.whiteVeil
        radius: strictStyle ? 0 : parent.width / 24
    }
    Column {
        id: column
        y: window.height * 0.005
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: window.height * 0.005
        Repeater {
            id: rep
            model: blockModel
            delegate: Item {
                property bool blockIndex: index
                clip: true
                height: col.height
                width: window.width / 1280 * 260
                z: -index + blockModel.count
                MouseArea {
                    id: colArea
                    anchors.fill: col
                    onWheel: {
                        if (index > 0) scroller.wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
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
                            enabled: type === "header" || enableByState(type, name, index, isOverlay)
                            function controlsAction(item) {
                                clickAction(item.name, item.type, item.index, [item.val1, item.val2])
                            }
                        }
                    }
                }
                ScrollerV {
                    id: scroller
                    enabled: index > 0
                    visible: index > 0
                    anchors.right: parent.right
                    height: blockRect.height - rep.itemAt(0).height - window.height * 0.01
                    contentItem: col
                    contentSize: col.height + window.height * 0.01
                }
            }
        }
    }

    function enableByState(type, name, index, isOverlay) {
        const layerIndex = leftPanelFunctions.getLayerIndex()
        if (blockRect.enabled) {
            switch (blockRect.state) {
            case "enabled": return true
            case "insertion": return isOverlay && layerIndex !== -1 ? !["Overlay", "Combination mask"].includes(name) : false
            case "insertion2": return !["Overlay", "Combination mask"].includes(name)
            case "layerSwap": return true
            }
        }
        else return false
    }

    function clickAction(name, type, index, val) {
        blockRect.name = name
        blockRect.type = type
        blockRect.index = index
        blockRect.val = val
        blockAction(index)
    }
}
