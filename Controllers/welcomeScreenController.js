function welcomeModelPopulation(model, blockModel, additionalModel, getState) {
    const state = getState()
    const files = fileIO.getTemporaryFiles(`${baseDir}/tmp`)

    const saveList = []
    let saves = JSON.parse(fileIO.read(`${baseDir}/settings.json`)).saves
    if (typeof(saves) !== "undefined") {
        for (const save of saves) {
            saveList.push(save.substring('file://'.length))
        }
        saves = fileIO.sort(saveList);
    }

    fileIO.removeThumbsWithoutProject(saveList.concat(files.map(file => JSON.parse(file).path)), `${baseDir}/thumbs`)

    const buttons = {
        actions: ['Create project', 'Open project', 'Settings', 'About', 'Quit'],
        about: ['GNU General Public License', 'GitHub', 'Actions']
    }
    let i = 0
    if (blockModel.count !== 0) {
        blockModel.remove(0)
        blockModel.insert(0, model.get(0))
    } else {
        for (; i < model.count; ++i) {
            blockModel.append(model.get(i))
        }
    }

    if (blockModel.get(2).module.count < 2) {
        blockModel.get(2).module.append({block: []})
        if (files.length > 0) {
            for (const k in files) {
                const file = JSON.parse(files[k])
                blockModel.get(2).module.get(1).block.append({
                                                                 wdth: 240,
                                                                 type: "slot",
                                                                 fileName: file.name,
                                                                 name: `Last modified:\n${file.date}\n${file.time}`,
                                                                 path: file.path,
                                                                 image: Qt.resolvedUrl(`file://${baseDir}/thumbs/${file.name}.png`),
                                                                 view: "normal,overlay",
                                                                 category: "welcome",
                                                                 isOverlay: false,
                                                                 val1: 0,
                                                                 val2: 0,
                                                                 options: [
                                                                     {"name": "Open project"},
                                                                     {"name": "Delete"}
                                                                 ]
                                                             })
            }
        } else {
            blockModel.get(2).module.get(1).block.append({
                                                             wdth: 240,
                                                             type: "textBlock",
                                                             fileName: "",
                                                             name: "No data yet",
                                                             path: "",
                                                             image: "",
                                                             view: "normal,overlay",
                                                             category: "welcome",
                                                             isOverlay: false,
                                                             val1: 0,
                                                             val2: 0,
                                                             options: []
                                                         })
        }
    }

    if (blockModel.get(1).module.count < 2) {
        blockModel.get(1).module.append({block: []})

        if (typeof(saves) !== "undefined" && saves.length > 0) {
            for (const save of saves) {
                const path = save.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2')
                const name = path.substring(path.lastIndexOf('/') + 1)
                blockModel.get(1).module.get(1).block.append({
                                                                 wdth: 240,
                                                                 type: "slot",
                                                                 fileName: name,
                                                                 name: name,
                                                                 path: save,
                                                                 image: Qt.resolvedUrl(`file://${baseDir}/thumbs/${name}.png`),
                                                                 view: "normal,overlay",
                                                                 category: "welcome",
                                                                 isOverlay: false,
                                                                 val1: 0,
                                                                 val2: 0,
                                                                 options: [
                                                                     {"name": "Open project"},
                                                                     {"name": "Delete"}
                                                                 ]
                                                             })
            }
        } else {
            blockModel.get(1).module.get(1).block.append({
                                                             wdth: 240,
                                                             type: "textBlock",
                                                             fileName: "",
                                                             name: "No data yet",
                                                             path: "",
                                                             image: "",
                                                             view: "normal,overlay",
                                                             category: "welcome",
                                                             isOverlay: false,
                                                             val1: 0,
                                                             val2: 0,
                                                             options: []
                                                         })
        }
    }

    if (state === "actions") {
        const filler = {
            wdth: 240,
            type: "buttonDark",
            name: "",
            view: "normal,overlay",
            category: "welcome",
            isOverlay: false,
            val1: 0,
            val2: 0
        }
        blockModel.get(0).module.get(0).block.setProperty(0, "name", "Actions")
        blockModel.get(0).module.append({"block": []})
        buttons[state].forEach(name => blockModel.get(0).module.get(1).block.append(Object.assign(filler, {"name": name})))
    } else if (state === "settings") {
        blockModel.get(0).module.get(0).block.setProperty(0, "name", "Settings")
        blockModel.get(0).module.append({"block": []})
        for (i = 0; i < additionalModel.count; ++i) {
            let addModel
            if (additionalModel.get(i).name === "Lights") {
                const themes = ['Dark purple', 'Light purple', 'Dark classic', 'Light classic', 'Tranquil']
                const themesItem = []
                themes.forEach(theme => {
                                   themesItem.push({
                                                         name: theme,
                                                         type: "buttonDark",
                                                         category: "welcome",
                                                         val1: 0,
                                                         bval1: 0,
                                                         max1: 1,
                                                         min1: 0,
                                                         wdth: 230
                                                     })
                               }
                               )
                addModel = Object.assign(additionalModel.get(i), { "items": themesItem })
            } else {
                addModel = additionalModel.get(i)
            }
            blockModel.get(0).module.get(1).block.append(JSON.parse(JSON.stringify(addModel)))
        }
        blockModel.get(0).module.get(1).block.append({
                                                         name: "Actions",
                                                         type: "buttonDark",
                                                         category: "welcome",
                                                         val1: 0,
                                                         val2: 0,
                                                         bval1: 0,
                                                         max1: 1,
                                                         min1: 0,
                                                         wdth: 240,
                                                         items: []
                                                     })
    } else if (state === "about") {
        const filler = {
            wdth: 240,
            type: "textBlock",
            name: `Qt version: ${version}

CoolPaint is free software based on Qt. Developed by Serhiienko Ihor. You are welcome to redistribute software under certain conditions.`,
            view: "normal,overlay",
            category: "welcome",
            isOverlay: false,
            val1: 0,
            val2: 0
        }
        const filler2 = {
            wdth: 240,
            type: "buttonGoto",
            name: "",
            view: "normal,overlay",
            category: "welcome",
            isOverlay: false,
            val1: 0,
            val2: 0
        }
        blockModel.get(0).module.get(0).block.setProperty(0, "name", "About")
        blockModel.get(0).module.append({"block": []})
        blockModel.get(0).module.get(1).block.append(filler)
        buttons[state].forEach(name => blockModel.get(0).module.get(1).block.append(Object.assign(filler2,
                                                                                                  name !== "Actions" ? {"name": name} : {"name": name, "type": "buttonDark"}
                                                                                                  )))
    }
}

function updatePopulation(model, blockModel, additionalModel, getState, setState) {
    const files = fileIO.getTemporaryFiles(`${baseDir}/tmp`)
    const saveList = []
    let i = 0
    let saves = JSON.parse(fileIO.read(`${baseDir}/settings.json`)).saves
    blockModel.remove(1, 2)
    if (typeof(saves) !== "undefined") {
        for (const save of saves) {
            saveList.push(save.substring('file://'.length))
        }
        saves = fileIO.sort(saveList);
    }

    fileIO.removeThumbsWithoutProject(saveList.concat(files.map(file => JSON.parse(file).path)), `${baseDir}/thumbs`)

    for (i = 1; i < model.count; ++i) {
        blockModel.append(model.get(i))
    }

    blockModel.get(1).module.append({block: []})
    if (typeof(saves) !== "undefined" && saves.length > 0) {
        for (const save of saves) {
            const path = save.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2')
            const name = path.substring(path.lastIndexOf('/') + 1)
            blockModel.get(1).module.get(1).block.append({
                                                             wdth: 240,
                                                             type: "slot",
                                                             fileName: name,
                                                             name: name,
                                                             path: save,
                                                             image: Qt.resolvedUrl(`file://${baseDir}/thumbs/${name}.png`),
                                                             view: "normal,overlay",
                                                             category: "welcome",
                                                             isOverlay: false,
                                                             val1: 0,
                                                             val2: 0,
                                                             options: [
                                                                 {"name": "Open project"},
                                                                 {"name": "Delete"}
                                                             ]
                                                         })
        }
    } else {
        blockModel.get(1).module.get(1).block.append({
                                                         wdth: 240,
                                                         type: "textBlock",
                                                         fileName: "",
                                                         name: "No data yet",
                                                         path: "",
                                                         image: "",
                                                         view: "normal,overlay",
                                                         category: "welcome",
                                                         isOverlay: false,
                                                         val1: 0,
                                                         val2: 0,
                                                         options: []
                                                     })
    }

    blockModel.get(2).module.append({block: []})
    if (files.length > 0) {
        for (const k in files) {
            const file = JSON.parse(files[k])
            blockModel.get(2).module.get(1).block.append({
                                                             wdth: 240,
                                                             type: "slot",
                                                             fileName: file.name,
                                                             name: `Last modified:\n${file.date}\n${file.time}`,
                                                             path: file.path,
                                                             image: Qt.resolvedUrl(`file://${baseDir}/thumbs/${file.name}.png`),
                                                             view: "normal,overlay",
                                                             category: "welcome",
                                                             isOverlay: false,
                                                             val1: 0,
                                                             val2: 0,
                                                             options: [
                                                                 {"name": "Open project"},
                                                                 {"name": "Delete"}
                                                             ]
                                                         })
        }
    } else {
        blockModel.get(2).module.get(1).block.append({
                                                         wdth: 240,
                                                         type: "textBlock",
                                                         fileName: "",
                                                         name: "No data yet",
                                                         path: "",
                                                         image: "",
                                                         view: "normal,overlay",
                                                         category: "welcome",
                                                         isOverlay: false,
                                                         val1: 0,
                                                         val2: 0,
                                                         options: []
                                                     })
    }
    if (blockModel.get(0).module.get(0).block.get(0).name === "Settings") {
        setState("settings")
        console.log(getState())
        blockModel.get(0).module.remove(1)
        blockModel.get(0).module.append({"block": []})
        for (i = 0; i < additionalModel.count; ++i) {
            let addModel
            if (additionalModel.get(i).name === "Lights") {
                const themes = ['Dark purple', 'Light purple', 'Dark classic', 'Light classic', 'Tranquil']
                const themesItem = []
                themes.forEach(theme => {
                                   themesItem.push({
                                                         name: theme,
                                                         type: "buttonDark",
                                                         category: "welcome",
                                                         val1: 0,
                                                         bval1: 0,
                                                         max1: 1,
                                                         min1: 0,
                                                         wdth: 230
                                                     })
                               }
                               )
                addModel = Object.assign(additionalModel.get(i), { "items": themesItem })
            } else {
                addModel = additionalModel.get(i)
            }
            blockModel.get(0).module.get(1).block.append(JSON.parse(JSON.stringify(addModel)))
        }
        blockModel.get(0).module.get(1).block.append({
                                                         name: "Actions",
                                                         type: "buttonDark",
                                                         category: "welcome",
                                                         val1: 0,
                                                         val2: 0,
                                                         bval1: 0,
                                                         max1: 1,
                                                         min1: 0,
                                                         wdth: 240,
                                                         items: []
                                                     })
    } else if (blockModel.get(0).module.get(0).block.get(0).name === "About") {
        setState("about")
    } else if (blockModel.get(0).module.get(0).block.get(0).name === "Actions") {
        setState("actions")
    }
}
