WorkerScript.onMessage = function(message) {
    function projectPopulation(result, text) {
        if (result) {
            let k = 0
            if (!!text.layers) {
                for (k = 0; k < text.layers.length; ++k) {
                    layersModel.append(text.layers[k])
                }
            }
            if (!!text.overlays) {
                for (k = 0; k < text.overlays.length; ++k) {
                    overlayEffectsModel.append(text.overlays[k])
                }
            }
            if (!!text.history) {
                for (k = 0; k < text.history.length; ++k) {
                    actionsLog.append(text.history[k])
                }
                if (!!text.stepIndex) funcList.setStepIndex = text.stepIndex
            }
            if (!!text.image) {
                if (!!text.temporary && text.temporary) {
                    funcList.setCurrentProjectPath = ''
                }
                funcList.setCurrentImagePath = text.image
                funcList.openDialogAccept = text.image
            }
            if (!!text.version) {
                funcList.setProjectVersion = text.version
            }
            funcList.historyBlockModelGeneration = 0
            funcList.updateLayersBlockModel = 0
            funcList.reDraw = 0
        } else {
            const notificationText = "Can't open the project: corrupted project file or unsupported version"
            funcList.openNotification = notificationText
        }
    }

    const layersModel = message.layersModel
    const overlayEffectsModel = message.overlayEffectsModel
    const actionsLog = message.actionsLog

    actionsLog.clear()
    overlayEffectsModel.clear()
    layersModel.clear()

    const funcList = {
        "setStepIndex": -1,
        "setCurrentImagePath": -1,
        "openDialogAccept": -1,
        "historyBlockModelGeneration": -1,
        "updateLayersBlockModel": -1,
        "reDraw": -1,
        "openNotification": -1,
        "setProjectVersion": -1
    }
    projectPopulation(message.result, message.text)
    layersModel.sync()
    overlayEffectsModel.sync()
    actionsLog.sync()
    WorkerScript.sendMessage({
                                 'result': true,
                                 funcList
                             })
}
