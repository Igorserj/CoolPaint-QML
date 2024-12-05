import QtQuick 2.15
import "Controls"

Rectangle {
    id: blockRect
    property var blockModel: []
    property int index: -1
    property string type: ''
    color: "transparent"
    height: 0.5 * parent.height - window.height * 0.005
    width: parent.width
    clip: true
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: window.height * 0.005
        Repeater {
            id: rep
            model: blockModel
            delegate: Item {
                height: col.height
                width: window.width / 1280 * 260
                z: -index + blockModel.count
                MouseArea {
                    anchors.fill: col
                    onWheel: {
                        scroller.wheelScroll(wheel.angleDelta.y)
                    }
                }
                Column {
                    id: col
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: window.height * 0.005
                    Repeater {
                        model: block
                        delegate: Controls {
                            enabled: blockRect.enabled
                            function controlsAction() {
                                blockRect.type = type
                                blockRect.index = index
                                blockAction()
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
    function blockAction() {}
}
