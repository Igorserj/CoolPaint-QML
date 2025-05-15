import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: effectsBlock
        enabled: imageAssigned
        blockModel: effectsBlockModel
        function blockAction() {
            console.log(state)
            if (!["insertion", "insertion2"].includes(state)) {
                controller.addLayer(name, type, effectsModel, layersModel, overlayEffectsModel, index)
                controller.layersBlockModelGeneration(layersModel, layersBlockModel)
                actionsLog.trimModel(stepIndex)
                actionsLog.append({
                                      block: 'Effects',
                                      name: `Added effect ${name}`,
                                      prevValue: {val: -1},
                                      value: {val: index},
                                      index: layersModel.count - 1, // layer number
                                      subIndex: -1, // sublayer number
                                      propIndex: -1, // sublayer property number
                                      valIndex: -1
                                  })
                stepIndex += 1
                leftPanelFunctions.setLayersBlockState("enabled")
            } else {
                const subIndex = state === "insertion" ? 0 : 1
                const overlayModel = overlayEffectsModel.getModel(layerIndex, subIndex)[0]
                actionsLog.trimModel(stepIndex)
                actionsLog.append({
                                      block: 'Effects',
                                      name: `Set overlay effect to ${name} at ${subIndex}`,
                                      prevValue: {
                                          overlayEffectsModel: JSON.parse(JSON.stringify(typeof(overlayModel) !== "undefined" ?
                                                                                             overlayModel :
                                                                                             {
                                                                                                 name: "",
                                                                                                 isOverlay: false,
                                                                                                 items: []
                                                                                             }
                                                                                         ))
                                      },
                                      value: {
                                          val: index
                                      },
                                      index: layerIndex, // layer number
                                      subIndex: subIndex, // sublayer number
                                      propIndex: -1, // sublayer property number
                                      valIndex: -1
                                  })
                stepIndex += 1
                state = controller.addOverlayLayer(state, effectsModel, overlayEffectsModel, index, layerIndex)
                manualLayerChoose(layerIndex)
                rightPanelFunctions.propertiesBlockUpdate()
                canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
            }
            modelFunctions.autoSave()
        }
        Component.onCompleted: {
            effectsBlockItem = this
        }
    }
    Block {
        id: layersBlock
        y: 0.5 * parent.height
        blockModel: layersBlockModel
        function blockAction() {
            if (state === "enabled") {
                if (!["insertion", "insertion2"].includes(leftPanelFunctions.getEffectsBlockState())) layerIndex = index
                controller.chooseLayer(type,
                                       layersModel,
                                       rightPanelFunctions.getPropertiesModel(),
                                       overlayEffectsModel,
                                       index,
                                       leftPanelFunctions.getEffectsBlockState,
                                       leftPanelFunctions.setEffectsBlockState,
                                       leftPanelFunctions.getLayerIndex,
                                       leftPanelFunctions.setLayerIndex
                                       )
                rightPanelFunctions.propertiesBlockUpdate()
            } else if (state === "layerSwap") {
                controller.swapLayers(layersModel, layersBlockModel, overlayEffectsModel, layerIndex, index)
                actionsLog.trimModel(stepIndex)
                actionsLog.append({
                                      block: 'Layers',
                                      name: `Swap layers ${name}`,
                                      prevValue: {val: layerIndex},
                                      value: {val: index},
                                      index: layerIndex, // layer number
                                      subIndex: -1, // sublayer number
                                      propIndex: -1, // sublayer property number
                                      valIndex: -1
                                  })
                stepIndex += 1
                layerIndex = index
                rightPanelFunctions.propertiesBlockUpdate()
                canvaFunctions.layersModelUpdate('', -1, 0, 0)
                state = "enabled"
                modelFunctions.autoSave()
            }
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
}
