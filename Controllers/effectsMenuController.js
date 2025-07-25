function effectsBlockAction(name, type, index, state, setState) {
    if (type !== "filter") {
        if (!["insertion", "insertion2", "replacement"].includes(state)) {
            controller.addLayer(name, type, effectsModel, layersModel, overlayEffectsModel, index)
            actionsLog.trimModel(stepIndex)
            actionsLog.append({
                                  block: 'Effects',
                                  name: `Added effect ${name}`,
                                  prevValue: { val: -1 },
                                  value: { val: index },
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
                                  value: { val: index },
                                  index: idx, // layer number
                                  subIndex: -1, // sublayer number
                                  propIndex: -1, // sublayer property number
                                  valIndex: -1
                              })
            stepIndex += 1
            leftPanelFunctions.setLayersBlockState("enabled")
        } else {
            const subIndex = getIterationIndex()
            const model = overlayEffectsModel.getModel(layerIndex, subIndex)[0]
            let overlayModel
            const overlayDefined = typeof(model) !== "undefined"
            if (overlayDefined) overlayModel = JSON.parse(JSON.stringify(model))
            actionsLog.trimModel(stepIndex)
            actionsLog.append({
                                  block: 'Effects',
                                  name: `Set overlay effect to ${name} at ${subIndex}`,
                                  prevValue: {
                                      overlayEffectsModel: overlayDefined ?
                                                               overlayModel :
                                                               {
                                                                   name: "",
                                                                   isOverlay: false,
                                                                   items: []
                                                               }
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
            setState(controller.addOverlayEffect(state, effectsModel, overlayEffectsModel, index, layerIndex))
            updatePropsBlock(subIndex)
            canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)

        }
        actionsLog.historyBlockModelGeneration()
        window.modelFunctions.autoSave()
    } else {
        let i = 0
        const effectProps = {
            "wdth": 240,
            "val1": 0,
            "val2": 0
        }
        switch (name) {
        case "All":
            effectsBlockModel.remove(1)
            effectsBlockModel.append({ block: [] })
            for (i = 0; i < effectsModel.count; ++i) {
                const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(i))), effectProps)
                effect.type = "buttonDark"
                effectsBlockModel.get(1).block.append(effect)
            }
            break
        case "Masks":
            effectsBlockModel.remove(1)
            effectsBlockModel.append({ block: [] })
            for (i = 0; i < effectsModel.count; ++i) {
                const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(i))), effectProps)
                effect.type = effect.isOverlay ? "buttonDark" : "empty"
                effectsBlockModel.get(1).block.append(effect)
            }
            break
        case "Color":
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
            effectsBlockModel.append({ block: [] })
            for (i = 0; i < effectsModel.count; ++i) {
                const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(i))), effectProps)
                effect.type = colorList.includes(effect.name) ? "buttonDark" : "empty"
                effectsBlockModel.get(1).block.append(effect)
            }
            break
        case "Blur & Unblur":
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
            effectsBlockModel.append({ block: [] })
            for (i = 0; i < effectsModel.count; ++i) {
                const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(i))), effectProps)
                effect.type = blurList.includes(effect.name) ? "buttonDark" : "empty"
                effectsBlockModel.get(1).block.append(effect)
            }
            break
        case "Transformation":
            const transformList = [
                                    "Scale",
                                    "Rotation",
                                    "Translate"
                                ]
            effectsBlockModel.remove(1)
            effectsBlockModel.append({ block: [] })
            for (i = 0; i < effectsModel.count; ++i) {
                const effect = JSON.parse(JSON.stringify(effectsModel.get(i)))
                effect.type = transformList.includes(effect.name) ? "buttonDark" : "empty"
                effect.wdth = 240
                effect.val1 = 0
                effect.val2 = 0
                effectsBlockModel.get(1).block.append(effect)
            }
            break
        }
    }
}

function layersBlockAction(name, type, index, state, setState) {
    if (state === "enabled") {
        const isInsert = ["insertion", "insertion2"].includes(leftPanelFunctions.getEffectsBlockState())
        const subIndex = getIterationIndex()
        let overlayModel0
        if (!isInsert) {
            leftPanelFunctions.setLayerIndex(index)
        } else if (isInsert && index < layerIndex) {
            const model = overlayEffectsModel.getModel(layerIndex, subIndex)
            if (model.length > 0) {
                overlayModel0 = JSON.parse(JSON.stringify(model[0]))
            } else {
                overlayModel0 = {
                    name: "",
                    isOverlay: false,
                    items: [
                        { "val1": -1 }
                    ]
                }
            }
        } else {
            const notificationText = "You can't choose a layer with same or bigger index for linking"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return
        }
        let isChoosable = false
        if (typeof(overlayModel0) === "undefined") {
            isChoosable = true
        } else if (typeof(overlayModel0.items[0]) !== "undefined" && overlayModel0.items[0].val1 !== index && index !== layerIndex) {
            isChoosable = true
        }
        if (isChoosable) {
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
        } else {
            const notificationText = "You have already selected this layer"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return
        }
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
            actionsLog.historyBlockModelGeneration()
            updatePropsBlock(subIndex)
            window.modelFunctions.autoSave()
            canvaFunctions.layersModelUpdate('', '', index, 0)
        } else if (!isInsert) {
            rightPanelFunctions.propertiesBlockUpdate()
        }
    } else if (state === "layerSwap") {
        let index1
        let index2
        if (type === "buttonLayers") {
            index1 = layerIndex
            index2 = layersBlockModel.get(1).block.get(index).idx
            const result = controller.swapLayers(layersModel, layersBlockModel, overlayEffectsModel, index1, index2)
            if (result) {
                actionsLog.trimModel(stepIndex)
                actionsLog.append({
                                      block: 'Layers',
                                      name: `Swap layers ${name}`,
                                      prevValue: { val: index1 },
                                      value: { val: index2 },
                                      index: index1, // layer number
                                      subIndex: -1, // sublayer number
                                      propIndex: -1, // sublayer property number
                                      valIndex: -1
                                  })
                setStepIndex(stepIndex + 1)
                setLayerIndex(index2)
                actionsLog.historyBlockModelGeneration()
                manualLayerChoose(index2)
                rightPanelFunctions.propertiesBlockUpdate()
                canvaFunctions.layersModelUpdate('', -1, 0, 0)
                setState("enabled")
                window.modelFunctions.autoSave()
            }
        } else if (type === "buttonReplace") {
            index1 = layerIndex
            index2 = layersBlockModel.get(1).block.get(index).idx
            moveLayer(index1, index2)
        }
    }
}
