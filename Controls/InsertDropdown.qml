import QtQuick 2.15
import "../Controllers/insertionController.js" as Controller

Rectangle {
    id: insertDropdown
    property int w: 240
    property int parentIndex: index
    readonly property int dropdownIndex: val1
    property string text: name
    height: childrenRect.height + window.height * 2 * 0.0075
    width: folder.width
    color: window.style.currentTheme.darkGlass
    radius: strictStyle ? 0 : width / 16
    anchors.horizontalCenter: parent.horizontalCenter
    Component.onCompleted: updating()
    Column {
        spacing: window.height * 0.0075
        y: spacing
        OverlayFolder {
            id: folder
            w: insertDropdown.w
            text: insertDropdown.text
        }
        Item {
            id: foldableArea
            height: childrenRect.height
            width: folder.width
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
                height: innerColumn.height + window.height * 0.02
                anchors.horizontalCenter: innerColumn.horizontalCenter
                color: window.style.currentTheme.pinkWhite
                radius: strictStyle ? 0 : parent.width / 24
            }
            Column {
                id: innerColumn
                y: window.height * 0.01
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: window.height * 0.0075
                Repeater {
                    id: innerBlock
                    ButtonDark {
                        w: insertDropdown.w * 0.95
                        text: name
                        function clickAction() {
                            dropdownChoose(name, index)
                            controlsAction({name, type, index, val1, val2})
                        }
                    }
                }
            }
        }
    }

    function dropdownChoose(name, index) {
        if (category !== "settings" && category !== "welcome") {
            Controller.dropdownChoose(name, index, setName, setVal, getVals, doNotLog, layersModel.get(leftPanelFunctions.getLayerIndex()).items, window.modelFunctions.autoSave, actionsLog, setStepIndex, canvaFunctions.layersModelUpdate)
        } else {
            Controller.dropdownChoose(name, index, setName, setVal, getVals, doNotLog, settingsMenuModel.get(parentIndex).items, window.modelFunctions.autoSave, actionsLog, setStepIndex, canvaFunctions.layersModelUpdate)
        }
    }

    function setName(newName) {
        name = newName
    }
    function setVal(value) {
        val1 = value
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
                name = `${model[0].name.substring(0, name.indexOf(":") + 1)} ${innerBlock.model.get(dropdownIndex).name}`
            } else {
                innerBlock.model = []
            }
        } else {
            model = settingsMenuModel.get(index)
            if (model.length !== 0) {
                innerBlock.model = model.items
                name = 'Color scheme'
            } else {
                innerBlock.model = []
            }
        }
    }
}
