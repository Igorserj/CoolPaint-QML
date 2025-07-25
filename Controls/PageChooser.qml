import QtQuick 2.15

Item {
    id: pageChooserItem
    property string text: ""
    property int w: 240
    width: biggerSide * w
    height: biggerSide * 60 / 2
    Item {
        x: parent.width * 0.05
        width: parent.width / 4.5
        height: label.height
        y: (parent.height - height) / 2
        Label {
            id: label
            text: pageChooserItem.text
        }
    }
    Item {
        id: buttonsContainer
        property alias row: row
        clip: true
        width: parent.width * 0.65
        height: childrenRect.height
        x: parent.width - width - parent.width * 0.05
        y: (parent.height - (scroller.state !== "disabled" ? scroller.height : 0) - height) / 2
        MouseArea {
            anchors.fill: parent
            onWheel: {
                scroller.wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
            }
        }
        Row {
            id: row
            width: childrenRect.width
            spacing: parent.width * 0.025
            Repeater {
                model: items
                Item {
                    width: controlsLoader.width
                    height: controlsLoader.height
                    Loader {
                        id: controlsLoader
                        sourceComponent: overlayControls[type]
                        onLoaded: {
                            width = Qt.binding(() => item.width)
                            height = Qt.binding(() => item.height)
                        }
                    }
                    OverlayControls {
                        id: overlayControls
                        function controlsAction() {
                            clickAction(name, 'filter', index, [val1, val2])
                        }
                    }
                }
            }
        }
    }

    ScrollerH {
        id: scroller
        x: parent.width - width - parent.width * 0.05
        width: buttonsContainer.width
        contentItem: buttonsContainer.row
        contentSize: buttonsContainer.row.width
        anchors.bottom: parent.bottom
    }
}
