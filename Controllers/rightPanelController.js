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
        newModel.view = "normal,overlay"
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
    // if (stepIndex !== -1) blockModel.get(1).block.setProperty(stepIndex, "enabled", false)
    for (let i = model.count-1; i >= 0; --i) {
        // [[category,export],[view,undefined],[name,Width],[type,slider],[wdth,0],[min1,506.6666666666667],[max1,2016],[bval1,760],[val1,453]]
        const newModel = {
            // name: `${model.get(i).block} ${model.get(i).name} ${model.get(i).value.val}`,
            name: model.get(i).name,
            val1: model.get(i).value/*,
            enabled: stepIndex === i*/
        }
        newModel.wdth = 240
        newModel.category = "history"
        newModel.type = "buttonDark"
        blockModel.get(1).block.append(newModel)
    }
}
