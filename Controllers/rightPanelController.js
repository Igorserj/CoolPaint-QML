function propertiesBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "Properties",
                                       view: "normal,overlay"
                                   })
    for (let i = 0; i < model.count; ++i) {
        const newModel = JSON.parse(JSON.stringify(model.get(i)))
        newModel.wdth = 240
        blockModel.get(1).block.append(newModel)
    }
}

function flushPropertiesBlockModel(blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "Properties",
                                       view: "normal,overlay"
                                   })
}

function viewsBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "View",
                                       view: "normal,overlay"
                                   })
    for (let i = 0; i < model.count; ++i) {
        const newModel = model.get(i)
        newModel.wdth = 240
        blockModel.get(1).block.append(newModel)
    }
}
