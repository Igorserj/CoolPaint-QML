import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml.WorkerScript 2.15
import Qt.labs.platform 1.1
import Coolpaint 1.0
import "Models"
import "Interface"
import "Controls"
import "./Controllers/mainController.js" as Controller

Window {
    id: window
    property var doNotLog: ['view', 'export', 'settings']
    property int stepIndex: -1
    property int iterationIndex: -1
    property var saveProj
    property int lightTheme: 0
    property bool uiEffects: false
    property var popUpFunctions: ({})
    property var actionBarFunctions: ({})
    property var canvaFunctions: ({})
    property var leftPanelFunctions: ({})
    property var rightPanelFunctions: ({})
    property var modelFunctions: {
        const ClassModel = Controller.modelFunctions
        return new ClassModel(layersModel, overlayEffectsModel, actionsLog, saveProj)
    }
    width: 1280
    height: 720
    visible: true
    title: qsTr("Cool Paint")
    onClosing: {
        if (actionsLog.count > 0) {
            close.accepted = false
            exitDialog.open()
            popUpFunctions.openNotification("All unsaved progress will be lost!", 0)
        } else {
            close.accepted = true
        }
    }
    Component.onCompleted: {
        settingsLoading()
        modelNormalisation()
    }
    FileIO {
        id: fileIO
    }
    UI {
        id: ui
    }
    EffectsModel {
        id: effectsModel
    }
    LayersModel {
        id: layersModel
    }
    OverlayEffectsModel {
        id: overlayEffectsModel
    }
    ViewsModel {
        id: viewsModel
    }
    ExportMenuModel {
        id: exportMenuModel
    }
    SettingsMenuModel {
        id: settingsMenuModel
    }
    ActionsLog {
        id: actionsLog
    }
    MouseArea {
        acceptedButtons: "NoButton"
        focus: true
        Keys.onPressed: {
            console.log("pressed")
            if (event.key === Qt.Key_Z && (event.modifiers & (Qt.ControlModifier && Qt.ShiftModifier))) {
                actionBarFunctions.redo()
            } else if (event.key === Qt.Key_Z && (event.modifiers & Qt.ControlModifier)) {
                actionBarFunctions.undo()
            } else if (event.key === Qt.Key_Escape) {
                popUpFunctions.closeValueDialog()
            }
        }
    }
    ExitDialog {
        id: exitDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
    WorkerScript {
        id: parserWorker
        source: "./Controllers/parsingScript.mjs"
        onMessage: {
            switch (messageObject.type) {
            case 'settings': {
                settingsPopulation(messageObject.result, messageObject.text)
                break
            }
            case 'project': {
                projectPopulation(messageObject.result, messageObject.text)
                break
            }
            }
        }
    }
    WorkerScript {
        id: normalisationWorker
        source: "./Controllers/effectsModelNormalisation.mjs"
    }

    //Range of categories 'layer', 'history', 'export', 'view', 'settings', ''
    function logAssign(historyMenuBlockModel, historyBlockModelGeneration) {
        actionsLog.historyMenuBlockModel = historyMenuBlockModel
        actionsLog.historyBlockModelGeneration = historyBlockModelGeneration
    }
    function settingsLoading() {
        const settingsFile = `${baseDir}/settings.json`
        const data = fileIO.read(settingsFile)
        if (data !== "") {
            let jsonData = ''
            try {
                jsonData = JSON.parse(data)
            } catch (error) {
                const notificationText = error.toString()
                // popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                console.log(notificationText)
                return
            }
            if (!!!jsonData.settings || (!!jsonData.layers || !!jsonData.overlays || !!jsonData.history)) {
                const notificationText = 'Settings file is corrupted, loading defaults'
                // popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                console.log(notificationText)
                return
            }
            parserWorker.sendMessage({ 'text': jsonData, 'type': 'settings' })
        } else {
            loadSettingsDeafaults()
        }
    }
    function settingsPopulation(result, jsonData) {
        if (result) {
            for (let i = 0; i < jsonData.settings.length; ++i) {
                const obj = jsonData.settings[i]
                if (obj.name === 'Count of autosaves') {
                    fileIO.remove(`${baseDir}/tmp`, parseInt(obj.val1))
                } else if (obj.name === 'Lights') {
                    lightTheme = obj.val1
                } else if (obj.name === "UI Effects") {
                    uiEffects = obj.val1
                }
            }
        } else {
            loadSettingsDeafaults()
        }
    }
    function projectPopulation(result, text) {
        if (result) {
            let k = 0
            layersModel.clear()
            overlayEffectsModel.clear()
            actionsLog.clear()
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
                if (!!text.stepIndex) stepIndex = text.stepIndex
            }
            leftPanelFunctions.updateLayersBlockModel()
            canvaFunctions.reDraw()
        } else {
            const notificationText = "Can't open the project: corrupted project file"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function loadSettingsDeafaults() {
        console.log('Loading defaults')
        const settingsFile = `${baseDir}/settings.json`
        const model = { 'settings': [] }
        for (let i = 0; i < settingsMenuModel.count - 2; ++i) {
            model.settings.push(settingsMenuModel.get(i))
        }
        const jsonData = JSON.stringify(model, null, '\t')
        const result = fileIO.write(settingsFile, jsonData)
    }

    function setIterationIndex(index) {
        iterationIndex = index
    }
    function getIterationIndex() {
        return iterationIndex
    }
    function modelNormalisation() {
        normalisationWorker.sendMessage({model: effectsModel})
    }
    function getStepIndex() {
        return stepIndex
    }
    function setStepIndex(newStepIndex) {
        stepIndex = newStepIndex
    }
}
