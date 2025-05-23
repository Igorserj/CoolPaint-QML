import QtQuick 2.15
import "../Controls"

Item {
    property alias propertiesBlock: propertiesBlock
    Block {
        id: propertiesBlock
        y: window.height * 0.01
        blockModel: propertiesBlockModel
        function blockAction() {
            if (name === "Open link") {
                leftPanelFunctions.manualLayerChoose(val[0])
                rightPanelFunctions.propertiesBlockUpdate()
            } else if (name === "Visible") {
                const layerIndex = leftPanelFunctions.getLayerIndex()
                const newVal = val[0] === 0 ? 1 : 0
                leftPanelFunctions.switchRendering(layerIndex, newVal)
                const blockModel = leftPanelFunctions.getLayersBlockModel().get(1).block
                blockModel.setProperty(layerIndex, 'isRenderable', Boolean(val[0]))
            } else if (name === "Inversion") {
                const newVal = val[0] === 0 ? 1 : 0
                const blockModel = rightPanelFunctions.getPropertiesBlockModel()
                canvaFunctions.layersModelUpdate("val1", newVal, leftPanelFunctions.getLayerIndex(), index)
                blockModel.get(1).block.setProperty(index, "val1", newVal)
            }
        }
    }
    Block {
        id: viewsBlock
        y: parent.height / 2 + window.height * 0.01
        blockModel: viewsBlockModel
        function blockAction() {}
    }
    Component.onCompleted: {
        spacer.upperBlock = propertiesBlock
        spacer.lowerBlock = viewsBlock
    }
}
