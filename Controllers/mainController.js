class modelFunctions {
    constructor(layersModel, overlayEffectsModel, actionsLog, saveProj)  {
        this.layersModel = layersModel
        this.overlayEffectsModel = overlayEffectsModel
        this.actionsLog = actionsLog
        this.saveProj = saveProj
        this.tmpFile = ""
    }

    getLayersModel(index) {
        return this.layersModel.get(index)
    }
    getLayersModelLength() {
        return this.layersModel.count
    }
    getOverlayEffectsModel(index) {
        return this.overlayEffectsModel.get(index)
    }
    getOverlayEffectsModelLength() {
        return this.overlayEffectsModel.count
    }
    getActionsLog(index) {
        return this.actionsLog.get(index)
    }
    getActionsLogLength() {
        return this.actionsLog.count
    }
    getTmp() {
        return this.tmpFile
    }
    createNewTmp() {
        this.tmpFile = `${baseDir}/tmp/${Date.now()}.json`
    }
    autoSave() {
        if (this.tmpFile === "") {
            this.createNewTmp()
        }
        projectSaved = false
        saveProj(this.tmpFile, true)
    }
}

function settingsBlockAction(index, name, settingsMenuModel, settingsMenuBlockModel) {
    let i = 0
    switch (name) {
    case "Apply and save": {
        const model = { 'settings': [], 'saves': [] }
        const settingsFile = `${baseDir}/settings.json`
        const saves = JSON.parse(fileIO.read(settingsFile)).saves
        for (; i < settingsMenuBlockModel.get(1).block.count - 2; ++i) {
            model.settings.push(settingsMenuBlockModel.get(1).block.get(i))
        }
        if (typeof(saves) !== "undefined") model.saves = saves
        const jsonData = JSON.stringify(model, null, '\t')
        const result = fileIO.write(settingsFile, jsonData)
        const settingsModel = settingsMenuModel.getValues()
        const savesCount = parseInt(settingsMenuBlockModel.get(1).block.get(settingsModel.autosaves[0]).val1)
        settingsMenuBlockModel.get(1).block.setProperty(settingsModel.autosaves[0], "val1", savesCount)
        setSaves(savesCount, settingsModel.autosaves[0])
        setStyle(settingsMenuBlockModel.get(1).block.get(settingsModel.style[0]).val1, settingsModel.style[0])
        setUiFx(settingsMenuBlockModel.get(1).block.get(settingsModel.effects[0]).val1, settingsModel.effects[0])
        setTheme(settingsMenuBlockModel.get(1).block.get(settingsModel.theme[0]).val1, settingsModel.theme[0])
        console.log('Writing to', settingsFile, 'success:', result)
        break
    }
    case "Revert": {
        const settingsFile = `${baseDir}/settings.json`
        const data = fileIO.read(settingsFile)
        if (data !== "") {
            const jsonData = JSON.parse(data)
            for (; i < jsonData.settings.length; ++i) {
                for (let j = 0; j < settingsMenuBlockModel.get(1).block.count; ++ j) {
                    if (settingsMenuBlockModel.get(1).block.get(j).name === jsonData.settings[i].name) {
                        settingsMenuBlockModel.get(1).block.setProperty(j, 'val1', parseInt(jsonData.settings[i].val1))
                        break
                    }
                }
            }
        }
        break
    }
    case "Lights": {
        // lightTheme = settingsMenuBlockModel.get(1).block.get(index).val1
        break
    }
    case "UI Effects": {
        // console.log("click")
        // uiEffects = settingsMenuBlockModel.get(1).block.get(index).val1
        break
    }
    }
}
