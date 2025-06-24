import QtQuick 2.15
import "../Controls"

Item {
    property alias propertiesBlock: propertiesBlock
    Block {
        id: propertiesBlock
        y: window.height * 0.01
        blockModel: propertiesBlockModel
        function blockAction() {
            if (type !== "filter") {
                if (name === "Open link") {
                    leftPanelFunctions.manualLayerChoose(val[0])
                    rightPanelFunctions.propertiesBlockUpdate()
                } else if (name === "Visible") {
                    const layerIndex = leftPanelFunctions.getLayerIndex()
                    const newVal = val[0] === 0 ? 1 : 0
                    leftPanelFunctions.switchRendering(layerIndex, newVal)
                    const blockModel = leftPanelFunctions.getLayersBlockModel().get(1).block
                    blockModel.setProperty(layerIndex, 'isRenderable', val[0] === 1)
                    if (showPreview) canvaFunctions.setHelperImage(layerIndex)
                    else canvaFunctions.disableHelper()
                    canvaFunctions.layersModelUpdate('', '', leftPanelFunctions.getLayerIndex())
                } else if (name === "Inversion") {
                    const newVal = val[0] === 0 ? 1 : 0
                    const blockModel = rightPanelFunctions.getPropertiesBlockModel()
                    canvaFunctions.layersModelUpdate("val1", newVal, leftPanelFunctions.getLayerIndex(), index)
                    blockModel.get(1).block.setProperty(index, "val1", newVal)
                } else if (name === "Alias") {
                    leftPanelFunctions.renamingLayer(leftPanelFunctions.getLayerIndex(), val[0])
                }
            } else {
                let i = 0
                const blockModel = propertiesBlockModel.get(0).block
                if (name === "None") {
                    // const filterable = ["Visible", "Alias"]
                    for (i = 0; i < blockModel.count; ++i) {
                        switch (blockModel.get(i).name.split(" ")[0]) {
                        case "Visible": {
                            blockModel.setProperty(i, "type", "empty")
                            break
                        }
                        case "Alias": {
                            blockModel.setProperty(i, "type", "empty")
                            break
                        }
                        }
                    }
                } else if (name === "All") {
                    // const filterable = ["Visible", "Alias"]
                    for (i = 0; i < blockModel.count; ++i) {
                        switch (blockModel.get(i).name.split(" ")[0]) {
                        case "Visible": {
                            blockModel.setProperty(i, "type", "buttonSwitch")
                            break
                        }
                        case "Alias": {
                            blockModel.setProperty(i, "type", "textField")
                            break
                        }
                        }
                    }
                } else if (name === "Visible" || name === "Alias") {
                    for (i = 0; i < blockModel.count; ++i) {
                        switch (blockModel.get(i).name.split(" ")[0]) {
                        case "Visible": {
                            blockModel.setProperty(i, "type", name === "Visible" ? "buttonSwitch" : "empty")
                            break
                        }
                        case "Alias": {
                            blockModel.setProperty(i, "type", name === "Alias" ? "textField" : "empty")
                            break
                        }
                        }
                    }
                } else if (name === "Remove") {
                    leftPanelFunctions.removeLayer(leftPanelFunctions.getLayerIndex(), true)
                } else if (name === "Replace") {
                    console.log("Replace mode", leftPanelFunctions.getEffectsBlockState())
                    setIterationIndex(-1)
                    if (leftPanelFunctions.getEffectsBlockState() !== "replacement") {
                        leftPanelFunctions.setEffectsBlockState("replacement")
                    } else {
                        leftPanelFunctions.setEffectsBlockState("enabled")
                    }
                }
            }
        }
    }
    Block {
        id: viewsBlock
        y: parent.height / 2 + window.height * 0.01
        blockModel: viewsBlockModel
        function blockAction() {
            if (name === "Mirroring") {
                canvaFunctions.setMirroring(val[0])
            } else if (name === "Smoothing") {
                canvaFunctions.setSmoothing(val[0])
                canvaFunctions.reDraw()
            } else if (name === "Show preview") {
                console.log('val',val[0])
                switchPreview(val[0])
            }
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = propertiesBlock
        spacer.lowerBlock = viewsBlock
    }
}
