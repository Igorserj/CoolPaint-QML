function menuActions(name, createProj, openDialog, openProjectDialog, saveFileDialog, exportFileDialog, saveProj, goHome) {
    switch (name) {
    case "New": createProj(); break;
    case "Open": openDialog.open(); break;
    case "Open project": openProjectDialog.open(); break;
    case "Save as": saveFileDialog.open(); break;
    case "Save": saveProj(getCurrentProjectPath(), false); break;
    case "Export": exportFileDialog.switchState(); break;
    case "Home": goHome(); break;
    }
}

function openDialogAccept(canvaFunctions, source, layersModel, exportModel) {
    canvaFunctions.setImage(source)
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

function saveProj(currentFile, fileIO, modelFunctions, temporary, openNotification, setCurrentProjectPath, getCurrentImagePath, getFinalImage) {
    if ((temporary || !currentFile.toString().includes("/tmp/")) && !projectSaved) {
        const model = { 'layers': [], 'overlays': [], 'history': [], stepIndex, temporary, 'image': getCurrentImagePath(), 'version': projectData.version }
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
        console.log("Saved", temporary, projectSaved)
        if (!temporary) {
            projectSaved = true
            setCurrentProjectPath(currentFile)
        }
        const path = currentFile.toString().replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2')
        fileIO.write(path + '.json', jsonData)

        if (!temporary) {
            const img = getFinalImage()
            const name = path.substring(path.lastIndexOf('/') + 1)
            const maxSize = img !== null ? Math.max(img.width, img.height) : 0
            img.grabToImage(result => {
                                result.saveToFile(`${baseDir}/thumbs/${name}.png`)
                            }, Qt.size((img.width / maxSize) * 200, (img.height / maxSize) * 200))
            addSavedProject(path + '.json')
        }
    } else if ((temporary || !currentFile.toString().includes("/tmp/")) && projectSaved) {
        const notificationText = "Project already saved"
        openNotification(notificationText, notificationText.length * 100)
    } else {
        const notificationText = "Can't save file to tmp folder"
        openNotification(notificationText, notificationText.length * 100)
    }
}
