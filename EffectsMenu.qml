import QtQuick 2.15

Item {
    Block {
        id: effectsBlock
        enabled: canva.imageAssigned
        blockModel: effectsBlockModel
        function blockAction() {
            console.log(state)
            if (!["insertion", "insertion2"].includes(state)) {
                controller.addLayer(name, type, effectsModel, layersModel, index)
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
                setLayersBlockState("enabled")
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
                rightPanel.propertiesBlockUpdate()
                canva.layersModelUpdate('', -1, layerIndex, 0)
            }
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
                layerIndex = index
                controller.chooseLayer(type, layersModel, rightPanel.propertiesModel, index, setEffectsBlockState)
                rightPanel.propertiesBlockUpdate()
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
                rightPanel.propertiesBlockUpdate()
                canva.layersModelUpdate('', -1, 0, 0)
                state = "enabled"
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
