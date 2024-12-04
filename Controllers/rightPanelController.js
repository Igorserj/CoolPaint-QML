function propertiesBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({block: []})
    blockModel.append({block: []})
    blockModel.get(0).block.append({
                                       wdth: 240,
                                       type: "header",
                                       name: "Properties"
                                   })
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({
                                           wdth: 240,
                                           type: model.get(i).type,
                                           name: model.get(i).name,
                                           min1: model.get(i).min1,
                                           max1: model.get(i).max1,
                                           val1: model.get(i).val1,
                                           bval1: model.get(i).bval1,
                                           min2: model.get(i).min2,
                                           max2: model.get(i).max2,
                                           val2: model.get(i).val2,
                                           bval2: model.get(i).bval2,
                                           idx: model.get(i).idx
                                       })
    }
    // console.log('ind', Object.entries(blockModel.get(1).block.get(0)))
}
