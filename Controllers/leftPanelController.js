function effectsBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({type: "header", wdth: 240, name: "Effects"})
    for (let i = 0; i < model.count; ++i) {
        const effect = JSON.parse(JSON.stringify(model.get(i)))
        effect.type = "buttonDark"
        effect.wdth = 240
        blockModel.get(1).block.append(effect)
    }
}

function layersBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({type: "header", wdth: 240, name: "Layers"})
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({type: "buttonLayers", wdth: 240, name: model.get(i).name})
    }
    // if (typeof(finisher) !== "undefined") finisher()
}

function addLayer(name, type, effectsModel, layersModel, index) {
    if (type === "buttonDark") {
        const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
        if (name !== "Overlay") effect.activated = true
        else effect.activated = false
        effect.idx = layersModel.count
        effect.overlay = false
        layersModel.append(effect)
    }
}

function chooseLayer(type, layersModel, propertiesModel, index, setEffectsBlockState) {
    if (type === "buttonLayers") {
        propertiesModel.clear()
        canva.disableManipulator()
        for (let i = 0; i < layersModel.get(index).items.count; ++i) {
            const item = JSON.parse(JSON.stringify(layersModel.get(index).items.get(i)))
            item.idx = index
            propertiesModel.append(item)
        }
        setEffectsBlockState("enabled")
    }
}

function addOverlayLayer(state, effectsModel, overlayModel, index, insertionIndex) {
    let overlayIndex = -1
    let i = 0
    // console.log(state, effectsModel, overlayModel, index, insertionIndex)
    if (state === "insertion") {
        for (; i < overlayModel.count; ++i) {
            if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === 0) {
                overlayIndex = i
            }
        }
        if (overlayIndex === -1) {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = 0
            effect.overlay = true
            effect.activated = false
            overlayModel.append(effect)
        } else {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = 0
            effect.overlay = true
            effect.activated = false
            overlayModel.set(overlayIndex, effect)
        }
    } else if (state === "insertion2") {
        for (; i < overlayModel.count; ++i) {
            if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === 1) {
                overlayIndex = i
            }
        }
        if (overlayIndex === -1) {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = 1
            effect.overlay = false
            effect.activated = false
            overlayModel.append(effect)
        } else {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = 1
            effect.overlay = false
            effect.activated = false
            overlayModel.set(overlayIndex, effect)
        }
    }
    return "enabled"
}
function swapLayers(model, blockModel, overlayEffectsModel, index1, index2) {
    rightPanel.resetPropertiesBlock()
    canva.deactivateEffects(Math.min(index1, index2))
    const item = JSON.parse(JSON.stringify(model.get(index1)))
    const overlayItemsIndex1 = overlayEffectsModel.getModel(index1, -1, 'index')
    const overlayItemsIndex2 = overlayEffectsModel.getModel(index2, -1, 'index')
    model.set(index1, JSON.parse(JSON.stringify(model.get(index2))))
    model.set(index2, item)
    let i = 0
    console.log(overlayItemsIndex1, overlayItemsIndex2)
    for (; i < overlayItemsIndex1.length; ++i) {
        overlayEffectsModel.setProperty(overlayItemsIndex1[i], 'idx', index2)
    }
    for (i = 0; i < overlayItemsIndex2.length; ++i) {
        overlayEffectsModel.setProperty(overlayItemsIndex2[i], 'idx', index1)
    }
    layersBlockModelGeneration(model, blockModel)
    if (layersModel.count > 0) canva.layersModelUpdate('', 0, 0, Math.min(index1, index2))
    updateLayersBlockModel()
}
