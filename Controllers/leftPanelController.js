function effectsBlockModelGeneration(model, blockModel) {
    const filters = ["All", "Masks", "Color", "Blur & Unblur"]
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       type: "header",
                                       wdth: 240,
                                       name: "Effects",
                                       val1: 0,
                                       val2: 0,
                                       isOverlay: false,
                                       items: []
                                   })
    const item = {
        "bval1": 0,
        "bval2": 0,
        "val1": 1,
        "val2": 0,
        "max1": 1,
        "max2": 1,
        "min1": 0,
        "min2": 0,
        "name": '',
        "wdth": 40,
        "type": "buttonWhite",
        "category": "filter"
    }
    const items = filters.map((filter) => {
                                 const it = JSON.parse(JSON.stringify(item))
                                 it.name = filter
                                 return it
                             })
    blockModel.get(0).block.append({
                                       type: "pageChooser",
                                       wdth: 240,
                                       name: "Filter",
                                       val1: 0,
                                       val2: 0,
                                       isOverlay: false,
                                       items
                                   })
    for (let i = 0; i < model.count; ++i) {
        const effect = JSON.parse(JSON.stringify(model.get(i)))
        effect.type = "buttonDark"
        effect.wdth = 240
        effect.val1 = 0
        effect.val2 = 0
        blockModel.get(1).block.append(effect)
    }
}

function layersBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({type: "header", wdth: 240, name: "Layers"})
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({
                                           "type": "buttonLayers",
                                           "wdth": 240,
                                           "name": model.get(i).name,
                                           "nickname": model.get(i).nickname,
                                           "val1": 0,
                                           "val2": 0,
                                           "idx": model.get(i).idx,
                                           "isRenderable": model.get(i).isRenderable
                                       })
    }
}

function addLayer(name, type, effectsModel, layersModel, overlayModel, index) {
    if (type === 'buttonDark') {
        const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
        if (!['Overlay', 'Combination mask', 'Color swap', 'Saturation'].includes(name)) {
            effect.activated = true
        } else if (name === 'Combination mask') {
            const blends = ['Combination', 'Union', 'Subtract', 'Intersection', 'Symmetric Difference']
            dropdownPopulation(blends, layersModel.count, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === 'Overlay') {
            const blends = ['Normal', 'Addition', 'Subtract', 'Difference', 'Multiply', 'Divide', 'Darken Only', 'Lighten Only', 'Dissolve', 'Smooth Dissolve', 'Screen', 'Overlay', 'Hard Light', 'Soft Light', 'Color Dodge', 'Color Burn', 'Linear Burn', 'Vivid Light', 'Linear Light', 'Hard Mix']
            dropdownPopulation(blends, layersModel.count, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === 'Color swap') {
            const options = ['Red', 'Green', 'Blue', 'Alpha', 'Null', 'Blank']
            dropdownPopulation(options, layersModel.count, effect, 'Red channel')
            dropdownPopulation(options, layersModel.count, effect, 'Green channel')
            dropdownPopulation(options, layersModel.count, effect, 'Blue channel')
            dropdownPopulation(options, layersModel.count, effect, 'Alpha channel')
            effect.activated = true
        } else if (name === 'Saturation') {
            const options = ['Average', 'Medium', 'Light', 'Dark', 'Saddle point']
            dropdownPopulation(options, layersModel.count, effect, 'Tone:')
            effect.activated = true
        }
        effect.isRenderable = true
        effect.idx = layersModel.count
        effect.overlay = false
        layersModel.append(effect)

        layersBlockModel.get(1).block.append(Object.assign({
                                           "type": "buttonLayers",
                                           "wdth": 240,
                                           "val1": 0,
                                           "val2": 0
                                       }, effect))
        canvaFunctions.layersModelUpdate('', -1, layersModel.count-1, 0)
    }
}

function chooseLayer(type, layersModel, propertiesModel, overlayModel, canvaFunctions, index, getEffectsBlockState, setEffectsBlockState, getLayerIndex, setLayerIndex) {
    const effectsBlockState = getEffectsBlockState()
    const filler = {
        "name": "",
        "type": "empty",
        "category": ""
    }
    let layer
    if (type === "buttonLayers" && !["insertion", "insertion2"].includes(effectsBlockState)) {
        propertiesUpdate(propertiesModel, layersModel, index, canvaFunctions)
        setEffectsBlockState("enabled")
        setLayerIndex(index)
        const preview = getPreview()
        if (preview) canvaFunctions.setHelperImage(index)
        else canvaFunctions.disableHelper()
    } else if (type === "buttonLayers" && ["insertion", "insertion2"].includes(effectsBlockState)) {
        let i = 0
        let overlayIndex = overlayModel.getModel(getLayerIndex(), getIterationIndex(), 'index')
        console.log("LayerIndex:", getLayerIndex(), ', index:', index, ', overlayIndex:', overlayIndex)
        layer = JSON.parse(JSON.stringify(layersModel.get(index)))
        layer.items = [
                    {
                        "bval1": 0,
                        "bval2": 0,
                        "val1": index,
                        "val2": 0,
                        "max1": 1,
                        "max2": 1,
                        "min1": 0,
                        "min2": 0,
                        "name": "Open link",
                        "type": "buttonDark",
                        "category": "layer"
                    }
                ]
        for (i = 0; i < 3; ++i) {
            layer.items.push(filler)
        }
        layer.idx = getLayerIndex()
        layer.iteration = getIterationIndex()
        layer.overlay = true
        layer.activated = false
        if (overlayIndex.length === 0) {
            overlayModel.append(layer)
        } else {
            overlayModel.set(overlayIndex[0], layer)
        }
        setEffectsBlockState("enabled")
        modelFunctions.autoSave()
        setIterationIndex(-1)
    }
}

function propertiesUpdate(propertiesModel, layersModel, index, canvaFunctions) {
    let i = 0
    propertiesModel.clear()
    canvaFunctions.disableManipulator()
    const newModel = {
        "isRenderable": layersModel.get(index).isRenderable,
        "nickname": layersModel.get(index).nickname,
        "items": []
    }
    for (; i < layersModel.get(index).items.count; ++i) {
        const item = JSON.parse(JSON.stringify(layersModel.get(index).items.get(i)))
        item.idx = index
        newModel.items.push(item)
    }
    propertiesModel.append(newModel)
}

function addOverlayEffect(state, effectsModel, overlayModel, index, insertionIndex, iterationIndex = -1) {
    let overlayIndex = -1
    const iterIndex = iterationIndex === -1 ? getIterationIndex() : iterationIndex
    let i = 0
    for (; i < overlayModel.count; ++i) {
        if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === iterIndex) {
            overlayIndex = i
        }
    }
    const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
    effect.idx = insertionIndex
    effect.iteration = iterIndex
    effect.overlay = state === "insertion"
    effect.activated = false
    if (overlayIndex === -1) {
        overlayModel.append(effect)
    } else {
        overlayModel.set(overlayIndex, effect)
    }

    setIterationIndex(-1)
    return "enabled"
}

function addOverlayLayer(state, effectsModel, overlayModel, index, insertionIndex, iterationIndex = -1) {
    let overlayIndex = -1
    const iterIndex = iterationIndex === -1 ? getIterationIndex() : iterationIndex
    let i = 0
    for (; i < overlayModel.count; ++i) {
        if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === iterIndex) {
            overlayIndex = i
        }
    }
    const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
    effect.idx = insertionIndex
    effect.iteration = iterIndex
    effect.overlay = state === "insertion"
    effect.activated = false
    if (overlayIndex === -1) {
        overlayModel.append(effect)
    } else {
        overlayModel.set(overlayIndex, effect)
    }
    setIterationIndex(-1)
    return "enabled"
}

function swapLayers(model, blockModel, overlayEffectsModel, index1, index2) {
    let isSwappable = true
    let i = 0
    console.log("SWAP0", layerIndex, index1, index2)
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        console.log("Swapping", index1, index2, overlayEffectsModel.get(i).idx
                    , overlayEffectsModel.get(i).items.get(0).name
                    , overlayEffectsModel.get(i).items.get(0).val1, overlayEffectsModel.get(i).idx)
        if ((overlayEffectsModel.get(i).items.get(0).name === "Open link"
             && overlayEffectsModel.get(i).items.get(0).val1 >= index2
             && overlayEffectsModel.get(i).idx <= index1) ||
                (overlayEffectsModel.get(i).items.get(0).name === "Open link"
                 && overlayEffectsModel.get(i).items.get(0).val1 >= index1
                 && overlayEffectsModel.get(i).idx <= index2)
                ) {
            isSwappable = false
            break
        }
    }
    if (!isSwappable) {
        const notificationText = "You can't swap layers because of linked layer"
        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        return false
    } else {
        for (i = layersModel.count * 2 - 2; i > 0; --i) {
            if (layersBlockModel.get(1).block.get(i).type === "buttonReplace") {
                layersBlockModel.get(1).block.remove(i)
            }
        }
        canvaFunctions.deactivateEffects(Math.min(index1, index2), false)
        const item = JSON.parse(JSON.stringify(model.get(index1)))
        const item2 = JSON.parse(JSON.stringify(model.get(index2)))
        item.idx = index2
        item2.idx = index1
        const overlayItemsIndex1 = overlayEffectsModel.getModel(index1, -1, 'index')
        const overlayItemsIndex2 = overlayEffectsModel.getModel(index2, -1, 'index')
        const overlayLinkIndices1 = []
        const overlayLinkIndices2 = []
        model.set(index1, item2)
        model.set(index2, item)
        console.log(overlayItemsIndex1, overlayItemsIndex2)
        for (i = 0; i < overlayItemsIndex1.length; ++i) {
            overlayEffectsModel.setProperty(overlayItemsIndex1[i], 'idx', index2)
        }
        for (i = 0; i < overlayItemsIndex2.length; ++i) {
            overlayEffectsModel.setProperty(overlayItemsIndex2[i], 'idx', index1)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            if (overlayEffectsModel.get(i).items.get(0).name === "Open link") {
                if (overlayEffectsModel.get(i).items.get(0).val1 === index1) {
                    overlayLinkIndices1.push(i)
                } else if (overlayEffectsModel.get(i).items.get(0).val1 === index2) {
                    overlayLinkIndices2.push(i)
                }
            }
        }
        for (i = 0; i < overlayLinkIndices1.length; ++i) {
            overlayEffectsModel.get(overlayLinkIndices1[i]).items.setProperty(0, "val1", index2)
        }
        for (i = 0; i < overlayLinkIndices2.length; ++i) {
            overlayEffectsModel.get(overlayLinkIndices2[i]).items.setProperty(0, "val1", index1)
        }
        blockModel.get(1).block.set(
                    index1, item2
                    )
        blockModel.get(1).block.set(
                    index2, item
                    )
        if (layersModel.count > 0) canvaFunctions.layersModelUpdate('', 0, Math.min(index1, index2))
        return true
    }
}

function switchState({
                     spacer,
                     parent,
                     setState,
                     getState,
                     canvaFunctions,
                     exportMenuModel,
                     exportMenuBlockModel,
                     settingsMenuBlockModel,
                     settingsMenuModel
                     }) {
    const state = getState()
    if (state === "export") {
        close(spacer, parent, setState)
    } else if (state === "default") {
        open(spacer, parent, canvaFunctions, exportMenuModel, exportMenuBlockModel, settingsMenuBlockModel, settingsMenuModel, setState)
    }
}

function open(spacer,
              parent,
              canvaFunctions,
              exportMenuModel,
              exportMenuBlockModel,
              settingsMenuBlockModel,
              settingsMenuModel,
              setState) {
    spacer.spacerReset()
    spacer.y = (parent.height - spacer.height) / 2
    spacer.upperBlock = undefined
    spacer.lowerBlock = undefined
    const sizes = canvaFunctions.getBaseImageDims()
    exportMenuModel.set(0,
                        {
                            "val1": sizes.width,
                            "max1": sizes.sourceW > sizes.aspectW * 1.5 ? sizes.sourceW : sizes.aspectW * 1.5,
                            "min1": sizes.sourceW < sizes.aspectW / 1.5 ? sizes.sourceW : sizes.aspectW / 1.5
                        }
                        )
    exportMenuModel.set(1,
                        {
                            "val1": sizes.height,
                            "max1": sizes.sourceH > sizes.aspectH * 1.5 ? sizes.sourceH : sizes.aspectH * 1.5,
                            "min1": sizes.sourceH < sizes.aspectH / 1.5 ? sizes.sourceH : sizes.aspectH / 1.5
                        }
                        )
    let i = 0
    exportMenuBlockModel.set(1, {
                                 'block': []
                             })
    for (; i < exportMenuModel.count; ++i) {
        exportMenuBlockModel.get(1).block.append(exportMenuModel.get(i))
    }
    populateSettings(settingsMenuBlockModel, settingsMenuModel)

    setState("export")
}

function populateSettings(settingsMenuBlockModel, settingsMenuModel) {
    let i
    settingsMenuBlockModel.set(1, {
                                   'block': []
                               })
    for (i = 0; i < settingsMenuModel.count; ++i) {
        const model = settingsMenuModel.get(i)
        const themes = ['Dark purple', 'Light purple', 'Dark classic', 'Light classic', 'Tranquil']
        if (model.name === "Lights") {
            model.items.clear()
            themes.forEach((theme) => {
                               model.items.append({
                                                      name: theme,
                                                      type: "buttonDark",
                                                      category: "settings",
                                                      val1: 0,
                                                      bval1: 0,
                                                      max1: 1,
                                                      min1: 0,
                                                      wdth: 230
                                                  })
                           }
                           )
        }
        settingsMenuBlockModel.get(1).block.append(model)
    }

    const settingsFile = `${baseDir}/settings.json`
    const data = fileIO.read(settingsFile)
    if (data !== "") {
        const jsonData = JSON.parse(data)
        for (i = 0; i < jsonData.settings.length; ++i) {
            for (let j = 0; j < settingsMenuBlockModel.get(1).block.count; ++ j) {
                if (settingsMenuBlockModel.get(1).block.get(j).name === jsonData.settings[i].name) {
                    settingsMenuBlockModel.get(1).block.setProperty(j, 'val1', parseInt(jsonData.settings[i].val1))
                    break
                }
            }
        }
    }
}

function close(spacer, parent, setState) {
    spacer.spacerReset()
    spacer.y = (parent.height - spacer.height) / 2
    spacer.upperBlock = undefined
    spacer.lowerBlock = undefined
    setState("default")
}

function removeOverlayLayer({
                            layerIndex,
                            index,
                            value,
                            overlayEffectsModel,
                            layersModel,
                            manualLayerChoose,
                            rightPanelFunctions,
                            canvaFunctions
                            }) {
    const modelIndex = overlayEffectsModel.getModel(layerIndex, index, 'index')[0]
    if (typeof(modelIndex) === "undefined") overlayEffectsModel.append(value)
    else overlayEffectsModel.set(modelIndex, value)
    layersModel.setProperty(layerIndex, "activated", false)
    manualLayerChoose(layerIndex)
    rightPanelFunctions.propertiesBlockUpdate()
    canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
}

function layerRecovery({
                       layerIndex,
                       value,
                       canvaFunctions,
                       layersModel,
                       overlayEffectsModel,
                       manualLayerChoose,
                       rightPanelFunctions,
                       updateLayersBlockModel
                       }) {
    let i = layerIndex
    const overlayModel = value.overlayEffectsModel
    const layersModelValue = value.layersModel
    canvaFunctions.deactivateEffects(layerIndex, false)
    for (; i < layersModel.count; ++i) {
        layersModel.setProperty(i, "idx", i + 1)
    }
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        let idx = overlayEffectsModel.get(i).idx
        if (idx >= layerIndex) overlayEffectsModel.setProperty(i, "idx", idx + 1)
        if (overlayEffectsModel.get(i).items.get(0).name === "Open link") {
            idx = overlayEffectsModel.get(i).items.get(0).val1
            if (idx >= layerIndex) overlayEffectsModel.get(i).items.setProperty(0, "val1", idx + 1)
        }
    }
    const filler = {
        "name": "Open link",
        "type": "buttonDark",
        "category": "layer"
    }
    for (i = 0; i < overlayModel.length; ++i) {
        overlayEffectsModel.insert(value.indices[i], overlayModel[i])
    }
    layersModel.insert(layerIndex, layersModelValue)

    const item = {
        "type": "buttonLayers",
        "wdth": 240,
        "val1": 0,
        "val2": 0
    }

    layersBlockModel.get(1).block.insert(layerIndex, Object.assign(item, layersModelValue))
    manualLayerChoose(layerIndex)
    rightPanelFunctions.propertiesBlockUpdate()
    canvaFunctions.setHelperImage(layerIndex)
    canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
}

function removeLayer({
                     index,
                     logging,
                     logRemove,
                     layersModel,
                     overlayEffectsModel,
                     canvaFunctions,
                     modelFunctions,
                     leftPanelFunctions,
                     rightPanelFunctions,
                     updateLayersBlockModel
                     }) {
    if (logging) logRemove(index)
    let i = index + 1
    const overlayIndices = []
    const linkIndices = []
    for (; i < layersModel.count; ++i) {
        layersModel.setProperty(i, "idx", i - 1)
    }
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        let idx = overlayEffectsModel.get(i).idx
        if (idx > index) overlayEffectsModel.setProperty(i, "idx", idx - 1)
        else if (idx === index) overlayIndices.push(i)
        if (overlayEffectsModel.get(i).items.count > 0 && overlayEffectsModel.get(i).items.get(0).name === "Open link") {
            idx = overlayEffectsModel.get(i).items.get(0).val1
            if (idx > index) overlayEffectsModel.get(i).items.setProperty(0, "val1", idx - 1)
            else if (idx === index) overlayIndices.push(i)
        }
    }
    canvaFunctions.deactivateEffects(index, false)
    layersModel.remove(index)
    canvaFunctions.setHelperImage(-1)
    layersBlockModel.get(1).block.remove(index)

    for (i = 0; i < overlayIndices.length; ++i) {
        overlayEffectsModel.remove(overlayIndices[i] - i)
    }
    if (logging) modelFunctions.autoSave()
    if (layersModel.count > 0) canvaFunctions.layersModelUpdate('', 0, 0, index)
    leftPanelFunctions.setEffectsBlockState("enabled")
    rightPanelFunctions.resetPropertiesBlock()
    canvaFunctions.disableManipulator()
    setIterationIndex(-1)
    rightPanelFunctions.resetPropertiesBlock()
    canvaFunctions.srcListRemove(index, 0)
}

function switchRendering({
                         index,
                         isRenderable,
                         layersModel,
                         canvaFunctions
                         }) {
    layersModel.setProperty(index, 'isRenderable', !isRenderable)
    canvaFunctions.layersModelUpdate('', -1, index, 0)
}

function setValue({
                  index,
                  subIndex,
                  propIndex,
                  valIndex,
                  value,
                  name,
                  layersModel,
                  manualLayerChoose,
                  rightPanelFunctions,
                  updateLayersBlockModel,
                  canvaFunctions,
                  overlayEffectsModel
                  }) {
    if (name.includes("Visible")) {
        layersModel.setProperty(index, "isRenderable", value === 1)
        layersBlockModel.get(1).block.setProperty(index, 'isRenderable', value === 1)
        if (getLayerIndex() === index) {
            const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(0).block
            for (let i = 0; i < propertiesBlockModel.count; ++i) {
                if (propertiesBlockModel.get(i).name === "Visible") {
                    propertiesBlockModel.setProperty(i, "val1", value)
                }
            }
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else if (name.includes("Inversion")) {
        layersModel.get(index).items.setProperty(subIndex, `val${valIndex+1}`, value)
        // layersBlockModel.get(1).block.get(index).items.setProperty(subIndex, `val${valIndex+1}`, value)
        if (getLayerIndex() === index) {
            const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
            propertiesBlockModel.setProperty(subIndex, `val${valIndex+1}`, value)
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else {
        if (subIndex === -1) {
            layersModel.get(index).items.setProperty(propIndex, `val${valIndex+1}`, value)
            if (getLayerIndex() === index) {
                const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
                propertiesBlockModel.setProperty(propIndex, `val${valIndex+1}`, value)
            }
            canvaFunctions.layersModelUpdate('', -1, index, valIndex)
        } else {
            const overlayIndex = overlayEffectsModel.getModel(index, subIndex, 'index')[0]
            overlayEffectsModel.get(overlayIndex).items.setProperty(propIndex, `val${valIndex+1}`, value)
            canvaFunctions.layersModelUpdate('', -1, index, valIndex)
        }
    }
}

function setBlendingMode({
                         index,
                         subIndex,
                         valIndex,
                         value,
                         layersModel,
                         manualLayerChoose,
                         rightPanelFunctions,
                         canvaFunctions
                         }) {
    layersModel.get(index).items.setProperty(subIndex, `val${valIndex+1}`, value)
    if (getLayerIndex() === index) {
        const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
        propertiesBlockModel.setProperty(subIndex, `val${valIndex+1}`, value)
        propertiesBlockModel.setProperty(subIndex, `name`, overlayEffectsModel.getModel(index, subIndex)[0].items.get(value).name)
    }
    canvaFunctions.layersModelUpdate('', -1, index, valIndex)
}

function logRemove({
                   index,
                   actionsLog,
                   getStepIndex,
                   setStepIndex,
                   layersModel,
                   overlayEffectsModel
                   }) {
    const stepIndex = getStepIndex()

    const overlayLinksModel = []
    const overlayLinksIndices = []
    for (let i = 0; i < overlayEffectsModel.count; ++i) {
        if (overlayEffectsModel.get(i).idx === index) {
            overlayLinksModel.push(overlayEffectsModel.get(i))
            overlayLinksIndices.push(i)
        }
        else if (overlayEffectsModel.get(i).items.get(0).name === "Open link" && overlayEffectsModel.get(i).items.get(0).val1 === index) {
            overlayLinksModel.push(overlayEffectsModel.get(i))
            overlayLinksIndices.push(i)
        }
    }

    actionsLog.trimModel(stepIndex)
    actionsLog.append({
                          "block": 'Layers',
                          "name": `Removed effect ${layersModel.get(index).name} at ${index}`,
                          "prevValue": {
                              "layersModel": JSON.parse(JSON.stringify(layersModel.get(index))),
                              "overlayEffectsModel": JSON.parse(JSON.stringify(overlayLinksModel)),
                              "indices": overlayLinksIndices
                          },
                          "value": {},
                          "index": index, // layer number
                          "subIndex": -1, // sublayer number
                          "propIndex": -1, // sublayer property number
                          "valIndex": -1
                      })
    setStepIndex(stepIndex + 1)
    actionsLog.historyBlockModelGeneration(actionsLog, actionsLog.historyMenuBlockModel)
}
