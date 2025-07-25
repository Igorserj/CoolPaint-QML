import QtQuick 2.15
import "../Controllers/insertionController.js" as Controller

Rectangle {
    id: insertButton
    property int parentIndex: index
    height: col.height + window.height * 2 * 0.0075
    width: overlayFolder.width
    color: window.style.currentTheme.darkGlass
    radius: strictStyle ? 0 : width / 16
    Component.onCompleted: updating()
    Column {
        id: col
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: window.height * 0.0075
        y: window.height * 0.0075
        OverlayFolder {
            id: overlayFolder
            text: name
        }
        Item {
            id: foldableArea
            width: overlayFolder.width
            height: childrenRect.height
            clip: true
            state: ""
            states: [
                State {
                    name: "default"
                    PropertyChanges {
                        target: opening
                        running: true
                    }
                },
                State {
                    name: "collapsed"
                    PropertyChanges {
                        target: collapsing
                        running: true
                    }
                }
            ]
            SequentialAnimation {
                id: collapsing
                PropertyAnimation {
                    target: foldableArea
                    property: "height"
                    to: 0
                    duration: strictStyle ? 0 : 500
                }
            }
            SequentialAnimation {
                id: opening
                PropertyAnimation {
                    target: foldableArea
                    property: "height"
                    to: foldableArea.childrenRect.height
                    duration: strictStyle ? 0 : 500
                }
            }
            Rectangle {
                width: parent.width * 0.975
                height: column.height + window.height * 0.0075 * 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : parent.width / 24
            }
            Column {
                id: column
                y: spacing
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: window.height * 0.0075
                ButtonDark {
                    id: insertButtonRect
                    w: 230
                    anchors.horizontalCenter: parent.horizontalCenter
                    SequentialAnimation {
                        id: flashAnimation
                        running: iterationIndex === index
                        loops: Animation.Infinite
                        PropertyAnimation {
                            target: insertButtonRect
                            property: "color"
                            from: style.currentTheme.darkGlassAccent
                            to: style.currentTheme.vinousGlass
                            duration: 1000
                            easing.type: strictStyle ? "OutExpo" : "InOutQuad"
                        }
                        PropertyAnimation {
                            target: insertButtonRect
                            property: "color"
                            from: style.currentTheme.vinousGlass
                            to: style.currentTheme.darkGlassAccent
                            duration: 1500
                            easing.type: strictStyle ? "OutExpo" : "OutQuad"
                        }
                        onStopped: {
                            insertButtonRect.color = style.currentTheme.darkGlass
                        }
                    }
                    function clickAction() {
                        console.log("click", flashAnimation.running)
                        Controller.activateInsertion(index, leftPanelFunctions, name, setIterationIndex, flashAnimation)
                    }
                }
                Item {
                    width: inversionLoader.width
                    height: inversionLoader.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    Loader {
                        id: inversionLoader
                        onLoaded: {
                            width = Qt.binding(() => item.width)
                            height = Qt.binding(() => item.height)
                        }
                        sourceComponent: {
                            if (name === "Mask") {
                                inversionControls.buttonSwitch
                            }
                        }
                    }
                    OverlayControls {
                        id: inversionControls
                        readonly property string category: "properties"
                        readonly property string type: "buttonSwitch"
                        readonly property string name: "Inversion"
                        readonly property string view: "normal,overlay"
                        readonly property real wdth: 230
                    }
                }
                Repeater {
                    id: innerBlock
                    Item {
                        width: controlsLoader.width
                        height: controlsLoader.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        Loader {
                            id: controlsLoader
                            sourceComponent:
                                (typeof(view) !== "undefined" ?
                                     overlayFolder.text === "Mask" ?
                                         view.includes("overlay") : view.includes("normal") : true)
                                && type !== "insertDropdown" ?
                                    overlayControls[type] : overlayControls['empty']
                            onLoaded: {
                                width = Qt.binding(() => item.width)
                                height = Qt.binding(() => item.height)
                            }
                        }
                        OverlayControls {
                            id: overlayControls
                        }
                    }
                }
            }
        }
    }
    function updating() {
        const model = overlayEffectsModel.getModel(leftPanelFunctions.getLayerIndex(), index)
        if (model.length !== 0) {
            innerBlock.model = model[0].items
            insertButtonRect.text = model[0].name
        } else {
            innerBlock.model = []
            insertButtonRect.text = ""
        }
    }
    function setFoldState(state) {
        foldableArea.state = state
    }
    function getFoldState() {
        return foldableArea.state
    }
}
