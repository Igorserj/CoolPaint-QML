WorkerScript.onMessage = function(message) {
    let maxLength = 0
    let i = 0
    const model = message.model
    const filler = {
        "category": "",
        "type": "empty",
        "name": ""
    }
    for (; i < model.count; ++i) {
        model.setProperty(i, "nickname", model.get(i).name)
        maxLength = Math.max(model.get(i).items.count, maxLength)
    }
    for (i = 0; i < model.count; ++i) {
        const itemsLength = model.get(i).items.count
        for (let j = itemsLength; j < maxLength; ++j) {
            model.get(i).items.append(filler)
        }
    }
    model.sync()
    console.log('Nick', Object.entries(model.get(0)))
}
