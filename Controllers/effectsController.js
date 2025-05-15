function addEffect(name) {
    switch (name) {
    case "Color shift": return colorShift
    case "Vignette": return vignette
    case "Saturation": return saturation
    case "Grain": return grain
    case "Black and white": return blackAndWhite
    case "Motion blur": return motionBlur
    case "Tone map": return toneMap
    case "Grid": return grid
    case "Color curve": return colorCurve
    case "Overlay": return overlayEffect
    case "Mirror": return mirrorEffect
    case "Color highlight": return colorHighlight
    case "Gaussian blur": return gaussianBlur
    case "Rotation": return rotationEffect
    case "Negative": return negativeEffect
    case "Combination mask": return combinationMask
    }
}

function setImage(ldr, img, isRenderable, index) {
    if (ldr.width !== 0 && ldr.height !== 0) {
        if (isRenderable) {
            ldr.grabToImage(result => img.source = result.url)
        } else {
            if (index > 0) {
                img.source = layersRepeater.itemAt(index - 1).children[1].source
            } else {
                img.source = baseImage.source
            }
        }
    } else {
        const notificationText = 'Nothing to show: you have not opened an image'
        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
    }
}

function reActivateLoader(layersModel, overlaysModel, index) {
    if (index + 1 < layersModel.count && !["Overlay", "Combination mask"].includes(layersModel.get(index + 1).name)) {
        layersModel.setProperty(index + 1, "activated", true)
    } else if (index + 1 < layersModel.count && ["Overlay", "Combination mask"].includes(layersModel.get(index + 1).name)) {
        let overlayIndex = []
        if (index + 1 <= overlaysModel.count) overlayIndex = overlaysModel.getModel(index + 1, 0, 'index')
        if (overlayIndex.length > 0) overlaysModel.setProperty(overlayIndex[0], 'activated', true)
    }
}

function reActivateLayer(layersModel, overlaysModel, idx, iteration) {
    let overlayIndex = []
    if (iteration === 0) {
        overlayIndex = overlaysModel.getModel(idx, 1, 'index')
        if (overlayIndex.length > 0) overlaysModel.setProperty(overlayIndex[0], 'activated', true)
    } else if (iteration === 1) {
        layersModel.setProperty(idx, "activated", true)
    }
}

function propertyPopulation(type, items, index) {
    let result;
    if (type === "one") {
        if (items !== null && items.count > 0) result = items.get(index).val1
        else result =  0
    } else if (type === "two") {
        if (items !== null && items.count > 0) result = Qt.point(items.get(index).val1, items.get(index).val2)
        else result = Qt.point(0, 0)
    }
    return result
}

function propertyPopulationDropdown(model, layerIndex, index) {
    const items = !!model.get(layerIndex) ? model.get(layerIndex).items : undefined;
    let result = -1;
    if (!!items) {
        if (items !== null && items.count > 0) result = items.get(index).val1
        else result =  0
    }
    return result
}

function srcPopulation(repeater, index, baseImage) {
    if (index === 0) return baseImage
    else if (repeater.itemAt(index-1) !== null) return repeater.itemAt(index-1).children[1]
}
