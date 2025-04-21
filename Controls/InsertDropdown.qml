import QtQuick 2.15

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
                        width: item.width
                        height: item.height
                        sourceComponent: overlayControls[type]
                    }
                    OverlayControls {
                        id: overlayControls
                        function controlsAction() {
                            dropdownChoose(name, index)
                        }
                    }
                }
            }
        }
    }
    StyleSheet {id: style}

    function dropdownChoose(optionName, optionIndex) {
        const logging = !doNotLog.includes(category)
        name = `Blending mode: ${optionName}`
        if (logging) logAction(optionIndex)
        val1 = optionIndex
        layersModel.get(leftPanel.layerIndex).items.setProperty(index, 'name', name)
        canva.layersModelUpdate('val1', val1, idx, index, -1)
        if (logging) autoSave()
    }

    function setFoldState(state) {
        foldableArea.state = state
    }
    function getFoldState() {
        return foldableArea.state
    }
    function updating() {
        const model = overlayEffectsModel.getModel(leftPanel.layerIndex, index)
        if (model.length !== 0) {
            innerBlock.model = model[0].items
            name = `Blending mode: ${innerBlock.model.get(dropdownIndex).name}`
        } else {
            innerBlock.model = []
        }
    }
    function logAction(val2) {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Set blending mode to ${innerBlock.model.get(val2).name}`,
                              prevValue: {val: val1},
                              value: {val: val2},
                              index: leftPanel.layerIndex, // layer number
                              subIndex: parentIndex, // sublayer number
                              propIndex: index, // sublayer property number
                              valIndex: 0
                          })
        console.log(Object.entries(actionsLog.get(actionsLog.count-1).prevValue), Object.entries(actionsLog.get(actionsLog.count-1).value))
        stepIndex += 1
    }
}
