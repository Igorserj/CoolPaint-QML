function propertiesBlockActions(type, name, val, index, showPreview, leftPanelFunctions, rightPanelFunctions, canvaFunctions, setIterationIndex) {
    if (type !== "filter") {
        if (name === "Open link") {
            leftPanelFunctions.manualLayerChoose(val[0])
            rightPanelFunctions.propertiesBlockUpdate()
        } else if (name === "Visible") {
            const layerIndex = leftPanelFunctions.getLayerIndex()
            leftPanelFunctions.setValue(layerIndex, -1, -1, 0, val[0], name) // index, subIndex, propIndex, valIndex, value, name
        } else if (name === "Inversion") {
            const layerIndex = leftPanelFunctions.getLayerIndex()
            const newVal = val[0] === 0 ? 1 : 0
            leftPanelFunctions.setValue(layerIndex, index, -1, 0, newVal, name)
        } else if (name === "Smoothing") {
            const layerIndex = leftPanelFunctions.getLayerIndex()
            leftPanelFunctions.setValue(layerIndex, -1, -1, 0, val[0], name)
        } else if (name === "Transparency") {
            const layerIndex = leftPanelFunctions.getLayerIndex()
            leftPanelFunctions.setValue(layerIndex, -1, -1, 0, val[0], name)
        } else if (name === "Alias") {
            const layerIndex = leftPanelFunctions.getLayerIndex()
            leftPanelFunctions.setValue(layerIndex, -1, -1, 0, val[0], 'Renamed layer')
        } else if (type === "slider" || type === "buttonSwitch") { // need to be moved to setValue
            const layerIndex = leftPanelFunctions.getLayerIndex()
            const parentIndex = val[1]
            canvaFunctions.layersModelUpdate('val1', val[0], layerIndex, index, parentIndex)
            console.log('PM',JSON.stringify(propertiesModel.get(0)))
            if (parentIndex === -1) propertiesModel.get(0).items.setProperty(index, 'val1', val[0])
        }
    } else {
        let i = 0
        const blockModel = rightPanelFunctions.getPropertiesBlockModel().get(0).block
        if (name === "None") {
            for (i = 0; i < blockModel.count; ++i) {
                switch (blockModel.get(i).name.split(" ")[0]) {
                case "Visible": {
                    blockModel.setProperty(i, "type", "empty")
                    break
                }
                case "Alias": {
                    blockModel.setProperty(i, "type", "empty")
                    break
                }
                case "Smoothing": {
                    blockModel.setProperty(i, "type", "empty")
                    break
                }
                case "Transparency": {
                    blockModel.setProperty(i, "type", "empty")
                    break
                }
                }
            }
        } else if (name === "All") {
            for (i = 0; i < blockModel.count; ++i) {
                switch (blockModel.get(i).name.split(" ")[0]) {
                case "Visible": {
                    blockModel.setProperty(i, "type", "buttonSwitch")
                    break
                }
                case "Alias": {
                    blockModel.setProperty(i, "type", "textField")
                    break
                }
                case "Smoothing": {
                    blockModel.setProperty(i, "type", "buttonSwitch")
                    break
                }
                case "Transparency": {
                    blockModel.setProperty(i, "type", "slider")
                    break
                }
                }
            }
        } else if (name === "Visible" || name === "Alias" || name === "Smoothing" || name === "Transparency") {
            for (i = 0; i < blockModel.count; ++i) {
                switch (blockModel.get(i).name.split(" ")[0]) {
                case "Visible": {
                    blockModel.setProperty(i, "type", name === "Visible" ? "buttonSwitch" : "empty")
                    break
                }
                case "Alias": {
                    blockModel.setProperty(i, "type", name === "Alias" ? "textField" : "empty")
                    break
                }
                case "Smoothing": {
                    blockModel.setProperty(i, "type", name === "Smoothing" ? "buttonSwitch" : "empty")
                    break
                }
                case "Transparency": {
                    blockModel.setProperty(i, "type", name === "Transparency" ? "slider" : "empty")
                    break
                }
                }
            }
        } else if (name === "Remove") {
            leftPanelFunctions.removeLayer(leftPanelFunctions.getLayerIndex(), true)
        } else if (name === "Replace") {
            setIterationIndex(-1)
            if (leftPanelFunctions.getEffectsBlockState() !== "replacement") {
                leftPanelFunctions.setEffectsBlockState("replacement")
            } else {
                leftPanelFunctions.setEffectsBlockState("enabled")
            }
        }
    }
}

function viewsBlockActions(name, val, canvaFunctions, switchPreview) {
    if (name === "Mirroring") {
        canvaFunctions.setMirroring(val[0])
    } else if (name === "Smoothing") {
        canvaFunctions.setSmoothing(val[0])
        canvaFunctions.reDraw()
    } else if (name === "Show preview") {
        console.log('val',val[0])
        switchPreview(val[0])
    } else if (name === "Scale") {
        canvaFunctions.setScaling(val[0])
    }
}
