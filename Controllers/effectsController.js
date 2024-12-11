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
    }
}

function setImage(ldr, img) {
    ldr.grabToImage(result => img.source = result.url)
    console.log("set image")
}

function reActivateLoader(layersModel, overlaysModel, index) {
    if (index < layersModel.count - 1 && layersModel.get(index + 1).name !== "Overlay") layersModel.setProperty(index + 1, "activated", true)
    else if (index < layersModel.count - 1 && layersModel.get(index + 1).name === "Overlay") {
        const overlay = overlaysModel.getModel(index + 1, 0)
        if (overlay.length > 0) overlay[0].activated = true
    }
}

function reActivateLayer(layersModel, overlaysModel, idx, iteration) {
    console.log('layer react')
    if (iteration === 0) {
        const overlay = overlaysModel.getModel(idx, 1)
        if (overlay.length > 0) overlay[0].activated = true
    } else layersModel.setProperty(idx, "activated", true)
}

function propertyPopulation(type, items, index) {
    if (type === "one") {
        return items.get(index).val1
    } else if (type === "two") {
        return Qt.point(items.get(index).val1, items.get(index).val2)
    }
}

function srcPopulation(repeater, index, baseImage) {
    console.log('src')
    if (index === 0) return baseImage
    else return repeater.itemAt(index-1).children[1]
}
