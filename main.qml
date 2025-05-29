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
    property alias style: style
    property var doNotLog: ['view', 'export', 'settings', 'welcome']
    property int stepIndex: -1
    property int iterationIndex: -1
    property var saveProj
    property bool uiFx: false
    property bool strictStyle: false
    property url currentProjectPath: ""
    property url currentImagePath: ""
    property bool projectSaved: true
    property bool settingsLoaded: false
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
        close.accepted = false
        closeWindow()
    }
    onSettingsLoadedChanged: {
        ui.sourceComponent = userInterface
    }
    Component.onCompleted: {
        checkFolders()
        settingsLoading()
        modelNormalisation()
    }
    FileIO {
        id: fileIO
    }
    Loader {
        id: ui
        width: parent.width
        height: parent.height
    }
    Component {
        id: userInterface
        UI {}
    }
    MouseArea {
        acceptedButtons: "NoButton"
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Z && (event.modifiers & (Qt.ControlModifier && Qt.ShiftModifier))) {
                actionBarFunctions.redo()
            } else if (event.key === Qt.Key_Z && (event.modifiers & Qt.ControlModifier)) {
                actionBarFunctions.undo()
            } else if (event.key === Qt.Key_Escape) {
                popUpFunctions.closeValueDialog()
            } else if (event.key === Qt.Key_S && (event.modifiers & (Qt.ControlModifier && Qt.ShiftModifier))) {
                popUpFunctions.openSaveDialog()
            } else if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
                saveProj(currentProjectPath, false)
            } else if (event.key === Qt.Key_O && (event.modifiers & (Qt.ControlModifier && Qt.ShiftModifier))) {
                popUpFunctions.openImageDialog()
            } else if (event.key === Qt.Key_O && (event.modifiers & Qt.ControlModifier)) {
                popUpFunctions.openProjectDialog((currentFile) => popUpFunctions.openProj(currentFile))
            } else if (event.key === Qt.Key_Q && (event.modifiers & Qt.ControlModifier)) {
                closeWindow()
            } else if (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier)) {
                createProject()
            }
        }
    }
    ValueDialog {
        id: valueDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        Component.onCompleted: {
            popUpFunctions.closeValueDialog = close
            popUpFunctions.openValueDialog = open
        }
    }
    Dialog {
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        Component.onCompleted: {
            popUpFunctions.closeDialog = close
            popUpFunctions.openDialog = open
        }
    }
    Notification {
        id: notification
        Component.onCompleted: {
            popUpFunctions.openNotification = open
            popUpFunctions.closeNotification = close
        }
    }
    ExitDialog {
        id: exitDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
    StyleSheet {id: style}
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
                // eraseModels(parserCallback, [messageObject])
                eraseModels()
                projectPopulation(messageObject.result, messageObject.text)
                if (typeof(messageObject.currentFile) !== "undefined" && !messageObject.currentFile.toString().includes(`${baseDir}/tmp`)) {
                    setCurrentProjectPath(messageObject.currentFile)
                    addSavedProject(messageObject.currentFile)
                }
                break
            }
            }
        }
    }
    function parserCallback(messageObject) {
        projectPopulation(messageObject.result, messageObject.text)
        if (typeof(messageObject.currentFile) !== "undefined" && !messageObject.currentFile.toString().includes(`${baseDir}/tmp`)) {
            setCurrentProjectPath(messageObject.currentFile)
            addSavedProject(messageObject.currentFile)
        }
    }
    WorkerScript {
        id: normalisationWorker
        source: "./Controllers/effectsModelNormalisation.mjs"
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
    WelcomeModel {
        id: welcomeModel
    }
    ActionsLog {
        id: actionsLog
    }

    //Range of categories 'layer', 'history', 'export', 'view', 'settings', 'welcome', ''
    function checkFolders() {
        fileIO.createDirectory(`${baseDir}/tmp`)
        fileIO.createDirectory(`${baseDir}/thumbs`)
    }
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
                console.log(notificationText)
                return
            }
            if (!!!jsonData.settings || (!!jsonData.layers || !!jsonData.overlays || !!jsonData.history)) { // ADD jsonData.saves
                const notificationText = 'Settings file is corrupted, loading defaults'
                console.log(notificationText)
                return
            }
            parserWorker.sendMessage({ 'text': jsonData, 'type': 'settings', 'currentFile': "" })
        } else {
            loadSettingsDeafaults()
            settingsLoaded = true
        }
    }
    function settingsPopulation(result, jsonData) {
        if (result) {
            const count = settingsMenuModel.count
            const settingsModel = settingsMenuModel.getValues()
            for (let i = 0; i < jsonData.settings.length; ++i) {
                const obj = jsonData.settings[i]
                if (obj.name === 'Count of autosaves') {
                    setSaves(parseInt(obj.val1), settingsModel.autosaves[0])
                    fileIO.remove(baseDir, parseInt(obj.val1))
                } else if (obj.name === 'Lights') {
                    setTheme(obj.val1, settingsModel.theme[0])
                } else if (obj.name === "UI Effects") {
                    setUiFx(obj.val1, settingsModel.effects[0])
                } else if (obj.name === "Strict style") {
                    setStyle(obj.val1, settingsModel.style[0])
                }
            }
        } else {
            loadSettingsDeafaults()
        }
        settingsLoaded = true
    }
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
                if (!!text.stepIndex) setStepIndex(text.stepIndex)
            }
            if (!!text.image) {
                if (!!text.temporary && text.temporary) {
                    setCurrentProjectPath('')
                }
                setCurrentImagePath(text.image)
                popUpFunctions.openDialogAccept(text.image)
            }
            leftPanelFunctions.updateLayersBlockModel()
            canvaFunctions.reDraw()
        } else {
            const notificationText = "Can't open the project: corrupted project file"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function settingsBlockAction(index, name, settingsMenuModel, settingsMenuBlockModel) {
        Controller.settingsBlockAction(index, name, settingsMenuModel, settingsMenuBlockModel)
    }
    function loadSettingsDeafaults() {
        console.log('Loading defaults')
        const settingsFile = `${baseDir}/settings.json`
        const model = { 'settings': [], 'saves': [] }
        for (let i = 0; i < settingsMenuModel.count - 2; ++i) {
            model.settings.push(settingsMenuModel.get(i))
        }
        const jsonData = JSON.stringify(model, null, '\t')
        const result = fileIO.write(settingsFile, jsonData)
    }
    function closeWindow() {
        if (!projectSaved) {
            close.accepted = false
            exitDialog.open()
            popUpFunctions.openNotification("All unsaved progress will be lost!", 0)
        } else {
            exitDialog.exit()
        }
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
    function getCurrentProjectPath() {
        return currentProjectPath
    }
    function setCurrentProjectPath(newPath) {
        currentProjectPath = newPath
    }
    function getCurrentImagePath() {
        return currentImagePath
    }
    function setCurrentImagePath(newPath) {
        currentImagePath = newPath
    }
    function setTheme(newTheme, index) {
        settingsMenuModel.setProperty(index, 'val1', newTheme)
        style.setTheme(newTheme)
    }
    function setUiFx(value, index) {
        settingsMenuModel.setProperty(index, 'val1', value)
        uiFx = value
    }
    function setSaves(value, index) {
        settingsMenuModel.setProperty(index, 'val1', value)
    }
    function setStyle(value, index) {
        settingsMenuModel.setProperty(index, 'val1', value)
        strictStyle = value
    }
    function createProject() {
        if (!projectSaved) {
            popUpFunctions.openDialog(
                        "Create a new project?",
                        "All unsaved progress will be lost!",
                        [{text: "Create new", type: "New project"}, {text: "Cancel", func: "close"}])
        } else {
            popUpFunctions.setWelcomeState("disabled")
            eraseModels()
            const notificationText = "Created new project"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function dialogCallback(type, value, func) {
        if (type === "New project") {
            switch (value) {
            case "Create new": {
                eraseModels()
                const notificationText = "Created new project"
                popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                break
            }
            }
        } else if (type === "Delete project") {
            popUpFunctions.deleteProject(...func)
        }
    }
    function addSavedProject(path) {
        if (typeof(path) !== "undefined") {
            const settingsFile = `${baseDir}/settings.json`
            const data = JSON.parse(fileIO.read(settingsFile))
            const saves = typeof(data.saves) !== "undefined" ? new Set(data.saves) : new Set()
            saves.add(path.toString())
            data.saves = Array.from(saves)
            fileIO.write(settingsFile, JSON.stringify(data, null, "\t"))
        }
    }
    function removeSavedProject(path) {
        if (typeof(path) !== "undefined") {
            const settingsFile = `${baseDir}/settings.json`
            const data = JSON.parse(fileIO.read(settingsFile))
            const saves = typeof(data.saves) !== "undefined" ? new Set(data.saves) : new Set()
            saves.delete(path.toString())
            data.saves = Array.from(saves)
            fileIO.write(settingsFile, JSON.stringify(data, null, "\t"))
        }
    }

    function eraseModels(callback, props) {
        console.log("erasing")
        canvaFunctions.deactivateEffects(0)
        canvaFunctions.resetImage()
        setStepIndex(-1)
        actionsLog.clear()
        overlayEffectsModel.clear()
        layersModel.clear()
        leftPanelFunctions.updateLayersBlockModel()
        rightPanelFunctions.resetPropertiesBlock()
        setCurrentProjectPath("")
        setCurrentImagePath("")
        modelFunctions.createNewTmp()
        if (typeof(callback) !== "undefined") callback(...props)
    }
}
