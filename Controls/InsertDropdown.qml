import QtQuick 2.15
import "../Controllers/insertionController.js" as Controller

Column {
    id: insertDropdown
    property int parentIndex: index
    readonly property int dropdownIndex: val1
    spacing: window.height * 0.005
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: updating()
    OverlayFolder {
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
                duration: 500
            }
        }
        SequentialAnimation {
            id: opening
            PropertyAnimation {
                target: foldableArea
                property: "height"
                to: foldableArea.childrenRect.height
                duration: 500
            }
        }
        Column {
            spacing: window.height * 0.005
            Repeater {
                id: innerBlock
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
                            if (category !== "settings") {
                                Controller.dropdownChoose(name, index, setName, setVal, getVals, doNotLog, layersModel.get(leftPanelFunctions.getLayerIndex()).items, modelFunctions.autoSave, actionsLog, setStepIndex, canvaFunctions.layersModelUpdate)
                            } else {
                                Controller.dropdownChoose(name, index, setName, setVal, getVals, doNotLog, settingsMenuModel.get(parentIndex).items, modelFunctions.autoSave, actionsLog, setStepIndex, canvaFunctions.layersModelUpdate)
                            }
                            clickAction()
                        }
                    }
                }
            }
        }
    }
    StyleSheet {id: style}

    function setName(newName) {
        name = newName
    }
    function setVal(value) {
        val1 = value
    }
    function setStepIndex(value) {
        stepIndex = value
    }
    function getVals() {
        return {
            val1,
            idx: typeof(idx) !== "undefined" ? idx : -1,
            name,
            index,
            layerIndex: leftPanelFunctions.getLayerIndex(),
            stepIndex,
            category
        }
    }
    function setFoldState(state) {
        foldableArea.state = state
    }
    function getFoldState() {
        return foldableArea.state
    }
    function updating() {
        let model
        if (category !== "settings") {
            model = overlayEffectsModel.getModel(leftPanelFunctions.getLayerIndex(), index)
            if (model.length !== 0) {
                innerBlock.model = model[0].items
                name = `Blending mode: ${innerBlock.model.get(dropdownIndex).name}`
            } else {
                innerBlock.model = []
            }
        } else {
            model = settingsMenuModel.get(index)
            if (model.length !== 0) {
                innerBlock.model = model.items
                // name = `Lights: ${innerBlock.model.get(dropdownIndex).name}`
                name = 'Lights'
            } else {
                innerBlock.model = []
            }
        }
    }
}
