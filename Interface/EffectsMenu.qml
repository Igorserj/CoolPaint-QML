import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: effectsBlock
        y: window.height * 0.01
        enabled: imageAssigned
        blockModel: effectsBlockModel
        function blockAction() {
            console.log(index, type, name, val)
            if (type !== "filter") {
                if (!["insertion", "insertion2", "replacement"].includes(state)) {
                    controller.addLayer(name, type, effectsModel, layersModel, overlayEffectsModel, index)
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
                } else if (state === "replacement") {
                    const idx = getLayerIndex()
                    const prevValue = {
                        "layersModel": JSON.parse(JSON.stringify(layersModel.get(idx))),
                        "overlayEffectsModel": JSON.parse(JSON.stringify(overlayEffectsModel.getModel(idx))),
                        "indices": overlayEffectsModel.getModel(idx, -1, "index")
                    }
                    replacingLayer(idx, index)
                    actionsLog.trimModel(stepIndex)
                    actionsLog.append({
                                          block: 'Effects',
                                          name: `Replaced effect at ${idx} by ${name}`,
                                          prevValue,
                                          value: {val: index},
                                          index: idx, // layer number
                                          subIndex: -1, // sublayer number
                                          propIndex: -1, // sublayer property number
                                          valIndex: -1
                                      })
                    stepIndex += 1
                    leftPanelFunctions.setLayersBlockState("enabled")
                } else {
                    const subIndex = getIterationIndex()
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
                    state = controller.addOverlayEffect(state, effectsModel, overlayEffectsModel, index, layerIndex)
                    updatePropsBlock(subIndex)
                    canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
                }
                console.log("AL", Object.entries(actionsLog.get(actionsLog.count-1)), actionsLog.count)
                actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
                modelFunctions.autoSave()
            } else {
                let i = 0
                switch (name) {
                case "All": {
                    effectsBlockModel.remove(1)
                    effectsBlockModel.append({block: []})
                    for (i = 0; i < effectsModel.count; ++i) {
                        const effect = JSON.parse(JSON.stringify(effectsModel.get(i)))
                        effect.type = "buttonDark"
                        effect.wdth = 240
                        effect.val1 = 0
                        effect.val2 = 0
                        effectsBlockModel.get(1).block.append(effect)
                    }
                    break
                }
                case "Masks": {
                    effectsBlockModel.remove(1)
                    effectsBlockModel.append({block: []})
                    for (i = 0; i < effectsModel.count; ++i) {
                        const effect = JSON.parse(JSON.stringify(effectsModel.get(i)))
                        effect.type = effect.isOverlay ? "buttonDark" : "empty"
                        effect.wdth = 240
                        effect.val1 = 0
                        effect.val2 = 0
                        effectsBlockModel.get(1).block.append(effect)
                    }
                    break
                }
                case "Color": {
                    const colorList = [
                                        "Color shift",
                                        "Saturation",
                                        "Color curve",
                                        "Negative",
                                        "Color fill",
                                        "Gamma correction",
                                        "Contrast correction",
                                        "Brightness correction",
                                        "Color swap"
                                    ]
                    effectsBlockModel.remove(1)
                    effectsBlockModel.append({block: []})
                    for (i = 0; i < effectsModel.count; ++i) {
                        const effect = JSON.parse(JSON.stringify(effectsModel.get(i)))
                        effect.type = colorList.includes(effect.name) ? "buttonDark" : "empty"
                        effect.wdth = 240
                        effect.val1 = 0
                        effect.val2 = 0
                        effectsBlockModel.get(1).block.append(effect)
                    }
                    break
                }
                case "Blur & Unblur": {
                    const blurList = [
                                       "Motion blur",
                                       "Gaussian blur",
                                       "Gaussian unblur",
                                       "Blur",
                                       "Unblur",
                                       "Pixelation",
                                       "Pixel sharpness"
                                   ]
                    effectsBlockModel.remove(1)
                    effectsBlockModel.append({block: []})
                    for (i = 0; i < effectsModel.count; ++i) {
                        const effect = JSON.parse(JSON.stringify(effectsModel.get(i)))
                        effect.type = blurList.includes(effect.name) ? "buttonDark" : "empty"
                        effect.wdth = 240
                        effect.val1 = 0
                        effect.val2 = 0
                        effectsBlockModel.get(1).block.append(effect)
                    }
                    break
                }
                }
            }
        }
        Component.onCompleted: {
            effectsBlockItem = this
        }
    }
    Block {
        id: layersBlock
        y: 0.5 * parent.height + window.height * 0.01
        blockModel: layersBlockModel
        function blockAction() {
            if (state === "enabled") {
                const isInsert = ["insertion", "insertion2"].includes(leftPanelFunctions.getEffectsBlockState())
                const subIndex = getIterationIndex()
                let overlayModel0
                if (!isInsert) {
                    leftPanelFunctions.setLayerIndex(index) // MOVE TO controller.chooseLayer
                } else if (isInsert && index < layerIndex) {
                    overlayModel0 = JSON.parse(JSON.stringify(typeof(overlayEffectsModel.getModel(layerIndex, subIndex)[0]) !== "undefined" ?
                                                                  overlayEffectsModel.getModel(layerIndex, subIndex)[0] :
                                                                  {
                                                                      name: "",
                                                                      isOverlay: false,
                                                                      items: []
                                                                  }
                                                              ))
                } else {
                    const notificationText = "You can't choose a layer with same or bigger index for linking"
                    popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                    return
                }
                controller.chooseLayer(type,
                                       layersModel,
                                       rightPanelFunctions.getPropertiesModel(),
                                       overlayEffectsModel,
                                       canvaFunctions,
                                       index,
                                       leftPanelFunctions.getEffectsBlockState,
                                       leftPanelFunctions.setEffectsBlockState,
                                       leftPanelFunctions.getLayerIndex,
                                       leftPanelFunctions.setLayerIndex
                                       )
                if (isInsert) {
                    const resultModel = overlayEffectsModel.getModel(layerIndex, subIndex)
                    const overlayModel1 = resultModel.length > 0 ? JSON.parse(JSON.stringify(resultModel[0])) : []
                    actionsLog.trimModel(stepIndex)
                    actionsLog.append({
                                          block: 'Effects',
                                          name: `Set overlay layer to ${name} at ${subIndex}`,
                                          prevValue: {
                                              overlayEffectsModel: overlayModel0
                                          },
                                          value: {
                                              overlayEffectsModel: overlayModel1
                                          },
                                          index: layerIndex, // layer number
                                          subIndex: subIndex, // sublayer number
                                          propIndex: -1, // sublayer property number
                                          valIndex: -1
                                      })
                    stepIndex += 1
                    actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
                    updatePropsBlock(subIndex)
                    modelFunctions.autoSave()
                    canvaFunctions.layersModelUpdate('', '', index, 0)
                } else {
                    rightPanelFunctions.propertiesBlockUpdate()
                }
            } else if (state === "layerSwap") {
                const index1 = layerIndex
                const index2 = layersBlockModel.get(1).block.get(index).idx
                const result = controller.swapLayers(layersModel, layersBlockModel, overlayEffectsModel, layerIndex, index2)
                if (result) {
                    console.log("SWAP 2", layerIndex, index)
                    actionsLog.trimModel(stepIndex)
                    actionsLog.append({
                                          block: 'Layers',
                                          name: `Swap layers ${name}`,
                                          prevValue: {val: index1},
                                          value: {val: index2},
                                          index: index1, // layer number
                                          subIndex: -1, // sublayer number
                                          propIndex: -1, // sublayer property number
                                          valIndex: -1
                                      })
                    setStepIndex(stepIndex + 1)
                    setLayerIndex(index2)
                    actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
                    manualLayerChoose(index2)
                    rightPanelFunctions.propertiesBlockUpdate()
                    canvaFunctions.layersModelUpdate('', -1, 0, 0)
                    state = "enabled"
                    modelFunctions.autoSave()
                }
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
