WorkerScript.onMessage = function(message) {
    function objectParser(objects, keyValue) {
        for (const object of objects) {
            const keys = Object.keys(object)
            for (const key of keys) {
                const value = object[key]
                let isExact = false
                keyValue.forEach(
                            obj => {
                                const partialStatement = (obj.key === key && obj.type === typeof(value) && (obj.validRange.length > 0 ? obj.validRange.includes(value) : true))
                                if (partialStatement && obj.list.length === 0) {
                                    isExact = true
                                } else if (partialStatement && obj.list.length > 0) {
                                    isExact = objectParser(value, obj.list)
                                }
                            }
                            )
                if (!isExact) return false
            }
        }
        return true
    }
    function settingsParser(text) {
        const controlsTypes = ['joystick', 'slider', 'buttonWhite', 'buttonDark', 'buttonLayers', 'buttonSwitch', /*'header',*/ /*'empty',*/ /*'insertButton',*/ 'insertDropdown']
        const categoriesList = [/*'layer', 'history', 'export', 'view',*/ 'settings'/*, ''*/]
        const keyValue = [
                           { key: "category", type: "string", list: [], validRange: categoriesList },
                           { key: "name", type: "string", list: [], validRange: [] },
                           { key: "type", type: "string", list: [], validRange: controlsTypes },
                           { key: "wdth", type: "number", list: [], validRange: [] },
                           { key: "min1", type: "number", list: [], validRange: [] },
                           { key: "max1", type: "number", list: [], validRange: [] },
                           { key: "bval1", type: "number", list: [], validRange: [] },
                           { key: "val1", type: "number", list: [], validRange: [] },
                           { key: "items", type: "object", list: [
                                   { key: "name", type: "string", list: [], validRange: [] },
                                   { key: "type", type: "string", list: [], validRange: controlsTypes },
                                   { key: "category", type: "string", list: [], validRange: categoriesList },
                                   { key: "val1", type: "number", list: [], validRange: [] },
                                   { key: "bval1", type: "number", list: [], validRange: [] },
                                   { key: "max1", type: "number", list: [], validRange: [] },
                                   { key: "min1", type: "number", list: [], validRange: [] },
                                   { key: "wdth", type: "number", list: [], validRange: [] }
                               ], validRange: [] }
                       ]
        return objectParser(text.settings, keyValue)
    }

    function projectParser(text) {
        const results = []
        const controlsTypes = ['joystick', 'slider', 'buttonWhite', 'buttonDark', 'buttonLayers', 'buttonSwitch', 'header', 'empty', 'insertButton', 'insertDropdown']
        const categoriesList = ['layer', 'history', 'export', 'view', /*'settings',*/, 'Effects', 'Layers', '']
        const viewsList = ["normal", "overlay", "normal,overlay"]
        const keyValues = [
                            [
                                { key: "isOverlay", type: "boolean", list: [], validRange: [] },
                                { key: "name", type: "string", list: [], validRange: [] },
                                { key: "activated", type: "boolean", list: [], validRange: [] },
                                { key: "idx", type: "number", list: [], validRange: [] },
                                { key: "overlay", type: "boolean", list: [], validRange: [] },
                                { key: "items", type: "object", list: [
                                        { key: "category", type: "string", list: [], validRange: categoriesList },
                                        { key: "type", type: "string", list: [], validRange: controlsTypes },
                                        { key: "name", type: "string", list: [], validRange: [] },
                                        { key: "view", type: "string", list: [], validRange: viewsList },
                                        { key: "min1", type: "number", list: [], validRange: [] },
                                        { key: "min2", type: "number", list: [], validRange: [] },
                                        { key: "max1", type: "number", list: [], validRange: [] },
                                        { key: "max2", type: "number", list: [], validRange: [] },
                                        { key: "val1", type: "number", list: [], validRange: [] },
                                        { key: "val2", type: "number", list: [], validRange: [] },
                                        { key: "bval1", type: "number", list: [], validRange: [] },
                                        { key: "bval2", type: "number", list: [], validRange: [] }
                                    ], validRange: [] }
                            ],
                            [
                                { key: "isOverlay", type: "boolean", list: [], validRange: [] },
                                { key: "name", type: "string", list: [], validRange: [] },
                                { key: "idx", type: "number", list: [], validRange: [] },
                                { key: "iteration", type: "number", list: [], validRange: [] },
                                { key: "overlay", type: "boolean", list: [], validRange: [] },
                                { key: "activated", type: "boolean", list: [], validRange: [] },
                                { key: "items", type: "object", list: [
                                        { key: "category", type: "string", list: [], validRange: categoriesList },
                                        { key: "type", type: "string", list: [], validRange: controlsTypes },
                                        { key: "name", type: "string", list: [], validRange: [] },
                                        { key: "view", type: "string", list: [], validRange: viewsList },
                                        { key: "min1", type: "number", list: [], validRange: [] },
                                        { key: "min2", type: "number", list: [], validRange: [] },
                                        { key: "max1", type: "number", list: [], validRange: [] },
                                        { key: "max2", type: "number", list: [], validRange: [] },
                                        { key: "val1", type: "number", list: [], validRange: [] },
                                        { key: "val2", type: "number", list: [], validRange: [] },
                                        { key: "bval1", type: "number", list: [], validRange: [] },
                                        { key: "bval2", type: "number", list: [], validRange: [] }
                                    ], validRange: [] }
                            ],
                            [
                                { key: "block", type: "string", list: [], validRange: categoriesList },
                                { key: "name", type: "string", list: [], validRange: [] },
                                { key: "prevValue", type: "object", list: [], validRange: [] },
                                { key: "value", type: "object", list: [], validRange: [] },
                                { key: "index", type: "number", list: [], validRange: [] },
                                { key: "subIndex", type: "number", list: [], validRange: [] },
                                { key: "propIndex", type: "number", list: [], validRange: [] },
                                { key: "valIndex", type: "number", list: [], validRange: [] }
                            ]
                        ]
        if (!!text.layers) {
            results.push(objectParser(text.layers, keyValues[0]))
        }
        if (!!text.overlays) {
            results.push(objectParser(text.overlays, keyValues[1]))
        }
        if (!!text.history) {
            results.push(objectParser(text.history, keyValues[2]))
        }
        return !results.includes(false)
    }

    let result = false;
    if (message.type === "settings") {
        result = settingsParser(message.text)
    } else if (message.type === "project") {
        result = projectParser(message.text)
    }
    WorkerScript.sendMessage({
                                 'result': true/*result*/,
                                 'text': message.text,
                                 'type': message.type
                             })
}
