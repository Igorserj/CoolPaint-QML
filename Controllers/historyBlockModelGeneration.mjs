WorkerScript.onMessage = function(message) {
    const model = message.model
    const blockModel = message.blockModel
    let i = 0
    const pageNo = message.pageNo

    blockModel.clear()
    blockModel.append({ block: [] })
    blockModel.append({ block: [] })
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
                                       name: `Page ${pageNo+1}`,
                                       val1: pageNo,
                                       val2: 0,
                                       items
                                   })

    for (i = model.count-1; i >= 0; --i) {
        const newModel = {
            "name": model.get(i).name
        }
        newModel.wdth = 240
        newModel.category = "history"
        newModel.type = i < model.count - (pageNo * 100) && i >= model.count - ((pageNo + 1) * 100) ? "buttonDark" : "empty"
        blockModel.get(1).block.append(newModel)
    }
    blockModel.sync()
}
