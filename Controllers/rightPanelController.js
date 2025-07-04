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
                                       max2: 0,
                                       items: []
                                   })
    if (model.count > 0) {
        const options = ["None", "All", "Visible", "Alias", "Replace", "Remove"]
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
        const items = options.map((option) => {
                                     const it = JSON.parse(JSON.stringify(item))
                                     it.name = option
                                     return it
                                 })
        blockModel.get(0).block.append({
                                           type: "pageChooser",
                                           wdth: 240,
                                           name: "Options",
                                           val1: 0,
                                           val2: 0,
                                           isOverlay: false,
                                           items
                                       })

        blockModel.get(0).block.append({
                                           wdth: 240,
                                           type: "empty",//"buttonSwitch",
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
        blockModel.get(0).block.append({
                                           wdth: 240,
                                           type: "empty",//"textField",
                                           name: `Alias ${model.get(0).nickname}`,
                                           view: "normal,overlay",
                                           category: "properties",
                                           val1: 0,
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

function historyBlockModelGeneration(model, blockModel, pageNo) {
    let no = 0
    let i = 0
    if (typeof(pageNo) === "undefined" && blockModel.get(0).block.count > 1) {
        no = Math.min(blockModel.get(0).block.get(1).val1, Math.floor(model.count / 100))
    } else if (typeof(pageNo) === "undefined" && !(blockModel.get(0).block.count > 1)) {
        no = 0
    } else {
        no = pageNo
    }
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "History",
                                       view: "normal,overlay",
                                       val1: 0
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
    const items = []
    for (i = 0; i < model.count / 100; ++i) {
        const it = JSON.parse(JSON.stringify(item))
        it.name = `${model.count - (i * 100)} - ${Math.max(0, model.count - ((i + 1) * 100))}`
        items.push(it)
    }
    blockModel.get(0).block.append({
                                       type: "pageChooser",
                                       wdth: 240,
                                       name: `Page ${no+1}`,
                                       val1: no,
                                       val2: 0,
                                       items
                                   })

    for (i = model.count-1; i >= 0; --i) {
        const newModel = {
            "name": model.get(i).name
        }
        newModel.wdth = 240
        newModel.category = "history"
        newModel.type = i < model.count - (no * 100) && i >= model.count - ((no + 1) * 100) ? "buttonDark" : "empty"
        blockModel.get(1).block.append(newModel)
    }
}

function metadataBlockModelGeneration(blockModel, imaegePath, projPath) {
    const model = JSON.parse(fileIO.getMetadata(projPath/*imaegePath*/))
    const sizes = canvaFunctions.getBaseImageDims()
    model["Dimensions"] = `Dimensions\nWidth: ${sizes.sourceW}\nHeight: ${sizes.sourceH}`
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "Metadata",
                                       view: "normal,overlay"
                                   })
    for (const item in model) {
        blockModel.get(1).block.append({
                                           wdth: 240,
                                           type: "textBlock",
                                           category: "metadata",
                                           name: model[item],
                                           view: "normal,overlay"
                                       })
    }
}
