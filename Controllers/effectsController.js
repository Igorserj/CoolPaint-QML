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
    }
}

function setImage(ldr, img) {
    ldr.grabToImage(result => img.source = result.url)
}

function reActivateLoader(layersModel, overlaysModel, index) {
    if (index < layersModel.count - 1 && layersModel.get(index + 1).name !== "Overlay") layersModel.setProperty(index + 1, "activated", true)
    else if (index < layersModel.count - 1 && layersModel.get(index + 1).name === "Overlay") {
        let overlay = []
        if (index + 1 < overlaysModel.count - 1) overlay = overlaysModel.getModel(index + 1, 0)
        if (overlay.length > 0) overlay[0].activated = true
    }
}

function reActivateLayer(layersModel, overlaysModel, idx, iteration) {
    if (iteration === 0) {
        const overlay = overlaysModel.getModel(idx, 1)
        if (overlay.length > 0) overlay[0].activated = true
    } else {
        layersModel.setProperty(idx, "activated", true)
    }
}

function propertyPopulation(type, items, index) {
    if (type === "one") {
        if (items !== null && items.count > 0) return items.get(index).val1
        else return 0
    } else if (type === "two") {
        if (items !== null && items.count > 0) return Qt.point(items.get(index).val1, items.get(index).val2)
        else return Qt.point(0, 0)
    }
}

function srcPopulation(repeater, index, baseImage) {
    if (index === 0) return baseImage
    else return repeater.itemAt(index-1).children[1]
}
