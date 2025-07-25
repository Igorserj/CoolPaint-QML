import QtQuick 2.15
import Qt.labs.platform 1.1
import "../Controls"
import "../Models"
import "../Controllers/menuController.js" as Controller

Item {
    x: (window.width - childrenRect.width) / 2
    y: window.height - childrenRect.height - 10
    Component.onCompleted: {
        window.saveProj = saveProj
        setPopUpFunctions()
    }
    Row {
        spacing: biggerSide * 6.5
        Repeater {
            model: menuModel
            delegate: Controls {
                enabled: name === "Save as" ? imageAssigned
                                            : name === "Save" ? (projectData.projectPath.toString() !== "" && !projectSaved && imageAssigned)
                                                              : true
                function controlsAction() {
                    console.log(name, projectData.projectPath.toString() !== "", !projectSaved, imageAssigned)
                    Controller.menuActions(name, createProject, openDialog, openProjDialog, saveDialog, leftPanelFunctions, saveProj, popUpFunctions.goHome)
                }
            }
        }
    }
    MenuModel {
        id: menuModel
    }
    FileDialog {
        id: saveDialog
        nameFilters: ["Project file (*.json)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            projectSaved = false
            saveProj(currentFile, false)
            rightPanelFunctions.metadataBlockModelGeneration()
        }
    }
    FileDialog {
        id: openProjDialog
        property var callback
        nameFilters: ["Project file (*.json)"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            const data = fileIO.read(currentFile)
            if (data !== "") {
                openedFileHandle(data, currentFile)
                callback && callback(currentFile)
            } else {
                const notificationText = 'Selected file is empty'
                popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            }
        }
    }
    FileDialog {
        id: openDialog
        nameFilters: ["Image file (*.jpeg *.jpg *.dng *.tif *.tiff *.png *.webp *.svg)"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            Controller.openDialogAccept(canvaFunctions, currentFile, layersModel, exportMenuModel)
            setCurrentImagePath(currentFile)
        }
    }

    function openedFileHandle(response, currentFile) {
        let text = ''
        try {
            text = JSON.parse(response)
        } catch (error) {
            const notificationText = error.toString()
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return
        }
        if (typeof(text) === "undefined" || !!text.settings || !(!!text.layers || !!text.overlays || !!text.history)) {
            const notificationText = 'You have selected the wrong project file!'
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return
        }
        parserWorker.sendMessage({ text, currentFile, 'type': 'project', build })
    }
    function saveProj(currentFile, temporary) {
        console.log(getCurrentProjectPath(), currentFile)
        if (currentFile.toString() !== "") {
            Controller.saveProj(currentFile, fileIO, modelFunctions, temporary, popUpFunctions.openNotification, setCurrentProjectPath, getCurrentImagePath, canvaFunctions.getFinalImage)
        } else {
            openSaveDialog()
        }
    }
    function openProjectDialog(callback) {
        openProjDialog.callback = callback
        openProjDialog.open()
    }
    function openSaveDialog() {
        if (imageAssigned) {
            saveDialog.open()
        } else {
            const notificationText = 'You have not opened an image'
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function openImageDialog() {
        openDialog.open()
    }
    function openDialogAccept(currentFile) {
        Controller.openDialogAccept(canvaFunctions, currentFile, layersModel, exportMenuModel)
    }
    function setPopUpFunctions() {
        popUpFunctions.openProjectDialog = openProjectDialog
        popUpFunctions.openSaveDialog = openSaveDialog
        popUpFunctions.openImageDialog = openImageDialog
        popUpFunctions.openDialogAccept = openDialogAccept
        popUpFunctions.openedFileHandle = openedFileHandle
    }
}
