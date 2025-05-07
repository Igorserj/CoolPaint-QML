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
    autoSave() {
        if (this.tmpFile === "") {
            this.tmpFile = `${baseDir}/tmp/${Date.now()}.json`
        }
        saveProj(this.tmpFile)
    }
}
