import QtQuick 2.15
import Qt.labs.platform 1.1
import "Controls"
import "Models"
import "Controllers/menuController.js" as Controller

Item {
    x: (window.width - childrenRect.width) / 2
    y: window.height - childrenRect.height
    Row {
        Repeater {
            model: menuModel
            delegate: Controls {
                function controlsAction() {
                    Controller.menuActions(index, openDialog, openProjDialog, saveDialog/*, exportFileDialog*/)
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
        // onAccepted: saveFile(currentFile)
    }

    FileDialog {
        id: openProjDialog
        nameFilters: ["Project file (*.json)"]
        fileMode: FileDialog.OpenFile
        // onAccepted: OF.openFile(currentFile, response => openedFileHandle(response.content))
    }

    FileDialog {
        id: openDialog
        nameFilters: ["Image file (*.jpeg *.jpg *.dng *.tif *.tiff *.png)"]
        fileMode: FileDialog.OpenFile
        onAccepted: Controller.openDialogAccept(canva, currentFile)
        // onAccepted: {
        //     imagePath = currentFile
        //     els.imagesIterator(0)
        // }
    }

    // function saveFile(currentFile) {
    //     // els.loaderUnload()
    //     const model = { 'applied': [], 'inserts': [] }
    //     let k = 0
    //     for (; k < ela.count; ++k) {
    //         model.applied.push(ela.get(k))
    //     }
    //     for (k = 0; k < im.count; ++k) {
    //         model.inserts.push(im.get(k))
    //     }
    //     const jsonData = JSON.stringify(model, null, '\t')
    //     const request = new XMLHttpRequest();
    //     request.open("PUT", currentFile.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2') + '.json', false);
    //     request.send(jsonData);
    //     // els.loaderLoad()
    // }

    // function openedFileHandle(response) {
    //     const text = JSON.parse(response)
    //     els.loaderUnload()
    //     ela.clear()
    //     im.clear()
    //     let data
    //     for (data of text.applied) {
    //         ela.append(data)
    //     }
    //     for (data of text.inserts) {
    //         im.append(data)
    //     }
    //     els.loaderLoad()
    //     // els.overlaysIterator(0, 0)
    //     els.effectsIterator(0)
    //     // for (let i = 0; i < ela.count; ++i) {
    //     //     els.effectsIterator(i)
    //     //     // els.imagesIterator(i)
    //     // }
    // }
}
