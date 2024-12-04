function effectsBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({type: "header", wdth: 240, name: "Effects"})
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({type: "buttonDark", wdth: 240, name: model.get(i).name})
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

function addLayer(type, effectsModel, layersModel, index) {
    if (type === "buttonDark") {
        const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
        effect.activated = true
        effect.idx = layersModel.count
        layersModel.append(effect)
        console.log(Object.entries(layersModel.get(effect.idx)))
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
