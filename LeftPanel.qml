import QtQuick 2.15
import "Controls"
import "Models"
import "Controllers/leftPanelController.js" as Controller

Rectangle {
    property alias effectsBlockState: effectsBlock.state
    property int layerIndex: -1
    width: window.width / 1280 * 260
    height: window.height
    color: "#302430"
    Block {
        id: effectsBlock
        enabled: canva.imageAssigned
        blockModel: effectsBlockModel
        function blockAction() {
            if (state === "enabled") {
                // console.log('model', Object.entries(effectsBlockModel.get(index).block.get(0)))
                Controller.addLayer(name, type, effectsModel, layersModel, index)
                Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
            } else {
                console.log('li', index, layerIndex)
                state = Controller.addOverlayLayer(state, effectsModel, overlayEffectsModel, index, layerIndex)
                rightPanel.propertiesBlockUpdate()
            }
        }
    }
    Block {
        y: 0.5 * parent.height
        blockModel: layersBlockModel
        function blockAction() {
            layerIndex = index
            Controller.chooseLayer(type, layersModel, rightPanel.propertiesModel, index)
            rightPanel.propertiesBlockUpdate()
        }
    }
    Component.onCompleted: {
        Controller.effectsBlockModelGeneration(effectsModel, effectsBlockModel)
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }

    EffectsBlockModel {
        id: effectsBlockModel
    }
    LayersBlockModel {
        id: layersBlockModel
    }
    function updateLayersBlockModel() {
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }
    function removeLayer(index) {
        let i = index + 1
        const overlayIndices = []
        for (; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "idx", i - 1)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            const idx = overlayEffectsModel.get(i).idx
            if (idx > index) overlayEffectsModel.setProperty(i, "idx", idx - 1)
            else if (idx === index) overlayIndices.push(i)
        }
        canva.deactivateEffects(index)
        layersModel.remove(index)
        for (i = 0; i < overlayIndices.length; ++i) {
            overlayEffectsModel.remove(overlayIndices[i] - i)
        }
        if (layersModel.count > 0) canva.layersModelUpdate('', 0, 0, index)
        rightPanel.resetPropertiesBlock()
        updateLayersBlockModel()
    }
}
