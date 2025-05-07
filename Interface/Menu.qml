import QtQuick 2.15
import Qt.labs.platform 1.1
import "../Controls"
import "../Models"
import "../Controllers/menuController.js" as Controller

Item {
    x: (window.width - childrenRect.width) / 2
    y: window.height - childrenRect.height - 10
    Component.onCompleted: window.saveProj = saveProj
    Row {
        Repeater {
            model: menuModel
            delegate: Controls {
                enabled: name === "Save as" ? imageAssigned : true
                function controlsAction() {
                    Controller.menuActions(index, openDialog, openProjDialog, saveDialog, leftPanelFunctions)
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
        onAccepted: saveProj(currentFile)
    }
    FileDialog {
        id: openProjDialog
        nameFilters: ["Project file (*.json)"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            const data = fileIO.read(currentFile)
            if (data !== "") {
                openedFileHandle(data)
            } else {
                const notificationText = 'Selected file has no data'
                popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            }
        }
    }
    FileDialog {
        id: openDialog
        nameFilters: ["Image file (*.jpeg *.jpg *.dng *.tif *.tiff *.png *.webp *.svg)"]
        fileMode: FileDialog.OpenFile
        onAccepted: Controller.openDialogAccept(canvaFunctions, currentFile, layersModel, exportMenuModel)
    }

    function openedFileHandle(response) {
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
        parserWorker.sendMessage({ text, 'type': 'project' })

    }
    function saveProj(currentFile) {Controller.saveProj(currentFile, fileIO, modelFunctions)}
}
