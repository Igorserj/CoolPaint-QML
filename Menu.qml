import QtQuick 2.15
import Qt.labs.platform 1.1
import "Controls"
import "Models"
import "Controllers/menuController.js" as Controller
import "./Controllers/openFile.js" as OF

Item {
    x: (window.width - childrenRect.width) / 2
    y: window.height - childrenRect.height
    Row {
        Repeater {
            model: menuModel
            delegate: Controls {
                function controlsAction() {
                    Controller.menuActions(index, openDialog, openProjDialog, saveDialog, exportFileDialog)
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
        onAccepted: OF.openFile(currentFile, response => openedFileHandle(response.content))
    }

    FileDialog {
        id: openDialog
        nameFilters: ["Image file (*.jpeg *.jpg *.dng *.tif *.tiff *.png)"]
        fileMode: FileDialog.OpenFile
        onAccepted: Controller.openDialogAccept(canva, currentFile, layersModel)
    }

    FileDialog {
        id: exportFileDialog
        // nameFilters: ["Image file (*.jpeg *.jpg *.dng *.tif *.tiff *.png)"]
        nameFilters: ["Joint Photographic Experts Group (*.jpeg)", "Digital Negative Specification (*.dng)", "Tagged Image File Format (*.tiff)", "Portable Network Graphics (*.png)"]
        fileMode: FileDialog.SaveFile
        selectedNameFilter.index: 0
        onAccepted: Controller.exportDialogAccept(canva.finalImage, currentFile, selectedNameFilter.extensions)
    }

    function saveProj(currentFile) {
        const model = { 'layers': [], 'overlays': [] }
        let k = 0
        for (; k < layersModel.count; ++k) {
            model.layers.push(layersModel.get(k))
        }
        for (k = 0; k < overlayEffectsModel.count; ++k) {
            model.overlays.push(overlayEffectsModel.get(k))
        }
        const jsonData = JSON.stringify(model, null, '\t')
        const request = new XMLHttpRequest();
        request.open("PUT", currentFile.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2') + '.json', false);
        request.send(jsonData);
    }

    function openedFileHandle(response) {
        const text = JSON.parse(response)
        layersModel.clear()
        overlayEffectsModel.clear()
        let k = 0
        for (; k < text.layers.length; ++k) {
            layersModel.append(text.layers[k])
        }
        for (k = 0; k < text.overlays.length; ++k) {
            overlayEffectsModel.append(text.overlays[k])
        }
        leftPanel.updateLayersBlockModel()
        canva.layersModelUpdate('', -1, 0, 0)
    }
}
