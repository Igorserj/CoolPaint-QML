function propertiesBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "Properties",
                                       view: "normal,overlay",
                                       category: "properties",
                                       val1: 0,
                                       val2: 0,
                                       min1: 0,
                                       min2: 0,
                                       max1: 0,
                                       max2: 0
                                   })
    if (model.count > 0) {
        blockModel.get(0).block.append({
                                           wdth: 240,
                                           type: "buttonSwitch",
                                           name: "Visible",
                                           view: "normal,overlay",
                                           category: "properties",
                                           val1: model.get(0).isRenderable ? 1 : 0,
                                           val2: 0,
                                           min1: 0,
                                           min2: 0,
                                           max1: 1,
                                           max2: 1
                                       })
        for (let i = 0; i < model.get(0).items.count; ++i) {
            const newModel = JSON.parse(JSON.stringify(model.get(0).items.get(i)))
            newModel.view = "normal,overlay"
            newModel.wdth = 240
            blockModel.get(1).block.append(newModel)
        }
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

function historyBlockModelGeneration(model, blockModel, stepIndex) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "History",
                                       view: "normal,overlay"
                                   })
    for (let i = model.count-1; i >= 0; --i) {
        const newModel = {
            name: model.get(i).name,
            val1: model.get(i).value
        }
        newModel.wdth = 240
        newModel.category = "history"
        newModel.type = "buttonDark"
        blockModel.get(1).block.append(newModel)
    }
}
