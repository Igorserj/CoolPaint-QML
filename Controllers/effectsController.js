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

function reActivateLoader(model, index) {
    if (/*source !== "" && */index < model.count - 1) model.setProperty(index + 1, "activated", true)
}

function propertyPopulation(type, items, index) {
    if (type === "one") {
        return items.get(index).val1
    } else if (type === "two") {
        return Qt.point(items.get(index).val1, items.get(index).val2)
    } else if (type === "overlay") {}
}

function srcPopulation(repeater, index, baseImage) {
    console.log('src')
    if (index === 0) return baseImage
    else return repeater.itemAt(index-1).children[1]
}
