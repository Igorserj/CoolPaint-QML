import QtQuick 2.15
import "../Controls"
import "../Controllers/effectsMenuController.js" as Controller

Item {
    Block {
        id: effectsBlock
        y: window.height * 0.01
        enabled: imageAssigned
        blockModel: effectsBlockModel
        function blockAction() { effectsBlockAction(name, type, index, state, setState) }
        function setState(newState) {
            state = newState
        }
        Component.onCompleted: {
            effectsBlockItem = this
        }
    }
    Block {
        id: layersBlock
        y: 0.5 * parent.height + window.height * 0.01
        blockModel: layersBlockModel
        function blockAction() { layersBlockAction(name, type, index, state, setState) }
        function setState(newState) {
            state = newState
        }
        Component.onCompleted: {
            layersBlockItem = this
        }
    }
    Component.onCompleted: {
        controller.effectsBlockModelGeneration(effectsModel, effectsBlockModel)
        controller.layersBlockModelGeneration(layersModel, layersBlockModel)
        spacer.upperBlock = effectsBlock
        spacer.lowerBlock = layersBlock
    }
    function effectsBlockAction(name, type, index, state, setState) {
        Controller.effectsBlockAction(name, type, index, state, setState)
    }
    function layersBlockAction(name, type, index, state, setState) {
        Controller.layersBlockAction(name, type, index, state, setState)
    }
    function updatePropsBlock(subIndex) {
        const blockModel = rightPanelFunctions.getPropertiesBlockModel()
        const model = JSON.parse(JSON.stringify(rightPanelFunctions.getPropertiesModel().get(0)))
        const newModel = model.items[subIndex]
        if (blockModel.count === 1 || typeof(newModel) === "undefined") {
            rightPanelFunctions.propertiesBlockUpdate()
        } else {
            newModel.view = "normal,overlay"
            newModel.wdth = 240
            blockModel.get(1).block.remove(subIndex)
            blockModel.get(1).block.insert(subIndex, newModel)
        }
    }
}
