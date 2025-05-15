WorkerScript.onMessage = function(message) {
    let maxLength = 0
    let i = 0
    const filler = {
        "category": "",
        "type": "empty",
        "name": ""
    }
    for (; i < message.model.count; ++i) {
        maxLength = Math.max(message.model.get(i).items.count, maxLength)
    }
    for (i = 0; i < message.model.count; ++i) {
        const itemsLength = message.model.get(i).items.count
        for (let j = itemsLength; j < maxLength; ++j) {
            message.model.get(i).items.append(filler)
        }
    }
    message.model.sync()
}
