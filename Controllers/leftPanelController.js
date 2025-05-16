function effectsBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       type: "header",
                                       wdth: 240,
                                       name: "Effects",
                                       val1: 0,
                                       val2: 0
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
                                           "val1": 0,
                                           "val2": 0,
                                           "isRenderable": model.get(i).isRenderable
                                       })
    }
}

function addLayer(name, type, effectsModel, layersModel, overlayModel, index) {
    if (type === "buttonDark") {
        const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
        if (!["Overlay", "Combination mask"].includes(name)) {
            effect.activated = true
        } else if (name === "Combination mask") {
            const blends = ['Combination', 'Union', 'Subtract', 'Intersection']
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
                "type": "buttonDark",
                "category": "layer"
            }
            const items = blends.map((blendName) => {
                                         const it = JSON.parse(JSON.stringify(item))
                                         it.name = blendName
                                         return it
                                     })
            const obj = {
                "isOverlay": false,
                "name": `Blending mode: ${blends[0]}`,
                "idx": layersModel.count,
                "iteration": 3,
                "overlay": false,
                "activated": false
            }
            obj.items = items
            overlayModel.append(obj)
            effect.activated = false
        } else if (name === "Overlay") {
            const blends = ['Addition', 'Subtract', 'Multiply', 'Divide']
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
                "type": "buttonDark",
                "category": "layer"
            }
            const items = blends.map((blendName) => {
                                         const it = JSON.parse(JSON.stringify(item))
                                         it.name = blendName
                                         return it
                                     })
            const obj = {
                "isOverlay": false,
                "name": `Blending mode: ${blends[0]}`,
                "idx": layersModel.count,
                "iteration": 2,
                "overlay": false,
                "activated": false
            }
            obj.items = items
            overlayModel.append(obj)
            effect.activated = false
        }
        effect.isRenderable = true
        effect.idx = layersModel.count
        effect.overlay = false
        layersModel.append(effect)
    }
}

function chooseLayer(type, layersModel, propertiesModel, overlayModel, index, getEffectsBlockState, setEffectsBlockState, getLayerIndex, setLayerIndex) {
    const effectsBlockState = getEffectsBlockState()
    const filler = {
        "name": "",
        "type": "empty",
        "category": ""
    }
    let layer
    if (type === "buttonLayers" && !["insertion", "insertion2"].includes(effectsBlockState)) {
        propertiesUpdate(propertiesModel, layersModel, index)
        setEffectsBlockState("enabled")
    } else if (type === "buttonLayers" && ["insertion", "insertion2"].includes(effectsBlockState)) {
        let i = 0
        let overlayIndex = overlayModel.getModel(getLayerIndex(), getIterationIndex(), 'index')
        console.log("LayerIndex:", getLayerIndex(), ', index:', index, ', overlayIndex:', overlayIndex)
        if (overlayIndex.length === 0) {
            layer = JSON.parse(JSON.stringify(layersModel.get(index)))
            console.log(Object.entries(layer))
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
            // layer.name = `Link to ${layer.name}`
            layer.idx = getLayerIndex()
            layer.iteration = getIterationIndex()
            layer.overlay = true
            layer.activated = false
            overlayModel.append(layer)
        } else {
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
            overlayModel.set(overlayIndex[0], layer)
        }
        setEffectsBlockState("enabled")
        modelFunctions.autoSave()
    }
}
function propertiesUpdate(propertiesModel, layersModel, index) {
    let i = 0
    propertiesModel.clear()
    canvaFunctions.disableManipulator()
    for (; i < layersModel.get(index).items.count; ++i) {
        const item = JSON.parse(JSON.stringify(layersModel.get(index).items.get(i)))
        item.idx = index
        propertiesModel.append(item)
    }
}

function addOverlayLayer(state, effectsModel, overlayModel, index, insertionIndex) {
    let overlayIndex = -1
    let i = 0
    if (state === "insertion") {
        for (; i < overlayModel.count; ++i) {
            if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === getIterationIndex()) {
                overlayIndex = i
            }
        }
        if (overlayIndex === -1) {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = getIterationIndex()
            effect.overlay = true
            effect.activated = false
            overlayModel.append(effect)
        } else {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = getIterationIndex()
            effect.overlay = true
            effect.activated = false
            overlayModel.set(overlayIndex, effect)
        }
    } else if (state === "insertion2") {
        for (; i < overlayModel.count; ++i) {
            if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === getIterationIndex()) {
                overlayIndex = i
            }
        }
        if (overlayIndex === -1) {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = getIterationIndex()
            effect.overlay = false
            effect.activated = false
            overlayModel.append(effect)
        } else {
            const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
            effect.idx = insertionIndex
            effect.iteration = getIterationIndex()
            effect.overlay = false
            effect.activated = false
            overlayModel.set(overlayIndex, effect)
        }
    }
    return "enabled"
}
function swapLayers(model, blockModel, overlayEffectsModel, index1, index2) {
    rightPanelFunctions.resetPropertiesBlock()
    canvaFunctions.deactivateEffects(Math.min(index1, index2))
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
    if (layersModel.count > 0) canvaFunctions.layersModelUpdate('', 0, 0, Math.min(index1, index2))
    updateLayersBlockModel()
}
