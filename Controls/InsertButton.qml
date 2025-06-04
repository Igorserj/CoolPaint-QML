import QtQuick 2.15
import "../Controllers/insertionController.js" as Controller

Column {
    id: insertButton
    property int parentIndex: index
    spacing: window.height * 0.005
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: updating()
    OverlayFolder {
        id: overlayFolder
        text: name
    }
    Item {
        id: foldableArea
        width: childrenRect.width
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
        ButtonDark {
            id: insertButtonRect

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
        Column {
            y: insertButtonRect.y + insertButtonRect.height + spacing
            spacing: window.height * 0.005
            Item {
                width: inversionLoader.width
                height: inversionLoader.height
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
                    property string category: "properties"
                    property string type: "buttonSwitch"
                    property string name: "Inversion"
                    property string view: "normal,overlay"
                }
            }
            Repeater {
                id: innerBlock
                Item {
                    width: controlsLoader.width
                    height: controlsLoader.height
                    Loader {
                        id: controlsLoader
                        sourceComponent: (typeof(view) !== "undefined" ?
                                              overlayFolder.text === "Mask" ?
                                                  view.includes("overlay") : view.includes("normal") : true) ?
                                             type === "insertDropdown" ?
                                                 insertDropdown : overlayControls[type] : overlayControls['empty']
                        onLoaded: {
                            width = Qt.binding(() => item.width)
                            height = Qt.binding(() => item.height)
                            console.log("Loaded", type)
                        }
                    }
                    OverlayControls {
                        id: overlayControls
                    }
                    Component {
                        id: insertDropdown
                        InsertDropdown {
                            function clickAction() {controlsAction({name, type, index, val1, val2})}
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
