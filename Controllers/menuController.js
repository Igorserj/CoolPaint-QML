function menuActions(index, openDialog, openProjectDialog, saveFileDialog, exportFileDialog) {
    switch (index) {
    case 0: openDialog.open(); break;
    case 1: openProjectDialog.open(); break;
    case 2: saveFileDialog.open(); break;
    case 3: exportFileDialog.switchState(); break;
    }
}

function openDialogAccept(canvaFunctions, source, layersModel, exportModel) {
    canvaFunctions.setImage(source)
    if (layersModel.count > 0) canvaFunctions.reDraw()
    const sizes = canvaFunctions.getBaseImageDims()
    exportModel.set(0, {
                        'bval1': sizes.aspectW,
                        'val1': sizes.width,
                        "max1": sizes.sourceW > sizes.aspectW * 1.5 ? sizes.sourceW : sizes.aspectW * 1.5,
                        "min1": sizes.sourceW < sizes.aspectW / 1.5 ? sizes.sourceW : sizes.aspectW / 1.5
                    })

    exportModel.set(1, {
                        'bval1': sizes.aspectH,
                        'val1': sizes.height,
                        "max1": sizes.sourceH > sizes.aspectH * 1.5 ? sizes.sourceH : sizes.aspectH * 1.5,
                        "min1": sizes.sourceH < sizes.aspectH / 1.5 ? sizes.sourceH : sizes.aspectH / 1.5
                    })
}

function saveProj(currentFile, fileIO, modelFunctions) {
    const model = { 'layers': [], 'overlays': [], 'history': [] }
    let k = 0
    for (k = 0; k < modelFunctions.getLayersModelLength(); ++k) {
        model.layers.push(modelFunctions.getLayersModel(k))
    }
    for (k = 0; k < modelFunctions.getOverlayEffectsModelLength(); ++k) {
        model.overlays.push(modelFunctions.getOverlayEffectsModel(k))
    }
    for (k = 0; k < modelFunctions.getActionsLogLength(); ++k) {
        model.history.push(modelFunctions.getActionsLog(k))
    }
    const jsonData = JSON.stringify(model, null, '\t')

    // Write using the C++ helper
    fileIO.write(currentFile.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2') + '.json', jsonData)
}
