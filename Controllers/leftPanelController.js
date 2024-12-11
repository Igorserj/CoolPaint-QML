function effectsBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({type: "header", wdth: 240, name: "Effects"})
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({type: "buttonDark", wdth: 240, name: model.get(i).name, isOverlay: model.get(i).isOverlay})
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

function chooseLayer(type, layersModel, propertiesModel, index) {
    if (type === "buttonLayers") {
        propertiesModel.clear()
        for (let i = 0; i < layersModel.get(index).items.count; ++i) {
            const item = layersModel.get(index).items
            item.setProperty(i,'idx', index)
            propertiesModel.append(item.get(i))
        }
    }
}

function addOverlayLayer(state, effectsModel, overlayModel, index, insertionIndex) {
    let overlayIndex = -1
    let i = 0
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
