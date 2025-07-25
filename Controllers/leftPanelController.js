class leftPanelProps {
    constructor()  {
        this.combinationModes = ['Combination', 'Union', 'Subtract', 'Intersection', 'Symmetric Difference']
        this.overlayModes = ['Normal', 'Addition', 'Subtract', 'Difference', 'Multiply', 'Divide', 'Darken Only', 'Lighten Only', 'Dissolve', 'Smooth Dissolve', 'Screen', 'Overlay', 'Hard Light', 'Soft Light', 'Color Dodge', 'Color Burn', 'Linear Burn', 'Vivid Light', 'Linear Light', 'Hard Mix']
        this.colorPresets = ['Red', 'Green', 'Blue', 'Alpha', 'Null', 'Blank']
        this.toneModes = ['Average', 'Medium', 'Light', 'Dark', 'Saddle point']
        this.colorChannels = ['RGB', 'RGBA', 'Alpha']
        this.axisList = ['X', 'Y', 'Z']
    }

    getDropDowns() {
        return {
            "overlay": 'Overlay',
            "mask": 'Combination mask',
            "colorSwap": 'Color swap',
            "saturation": 'Saturation',
            "blackAndWhite": 'Black and white',
            "colorHighlight": 'Color highlight',
            "rotation": 'Rotation'
        }
    }
}


function effectsBlockModelGeneration(model, blockModel) {
    const filters = ["All", "Masks", "Color", "Blur & Unblur", "Transformation"]
    blockModel.clear()
    blockModel.append({ block: [] })
    blockModel.append({ block: [] })
    blockModel.get(0).block.append({
                                       type: "header",
                                       wdth: 240,
                                       name: "Effects",
                                       val1: 0,
                                       val2: 0,
                                       isOverlay: false,
                                       items: []
                                   })
    const item = {
        "bval1": 0,
        "bval2": 0,
        "val1": 1,
        "val2": 0,
        "max1": 1,
        "max2": 1,
        "min1": 0,
        "min2": 0,
        "name": '',
        "wdth": 40,
        "type": "buttonWhite",
        "category": "filter"
    }
    const items = filters.map((filter) => {
                                 const it = JSON.parse(JSON.stringify(item))
                                 it.name = filter
                                 return it
                             })
    blockModel.get(0).block.append({
                                       type: "pageChooser",
                                       wdth: 240,
                                       name: "Filter",
                                       val1: 0,
                                       val2: 0,
                                       isOverlay: false,
                                       items
                                   })
    for (let i = 0; i < model.count; ++i) {
        const effect = JSON.parse(JSON.stringify(model.get(i)))
        effect.type = "buttonDark"
        effect.wdth = 240
        effect.val1 = 0
        effect.val2 = 0
        blockModel.get(1).block.append(effect)
    }
}

function layersBlockModelGeneration(model, blockModel) {
    blockModel.clear()
    blockModel.append({ block: [] })
    blockModel.append({ block: [] })
    blockModel.get(0).block.append({ type: "header", wdth: 240, name: "Layers" })
    for (let i = 0; i < model.count; ++i) {
        blockModel.get(1).block.append({
                                           "type": "buttonLayers",
                                           "wdth": 240,
                                           "name": model.get(i).name,
                                           "nickname": model.get(i).nickname,
                                           "val1": 0,
                                           "val2": 0,
                                           "idx": model.get(i).idx,
                                           "isRenderable": model.get(i).isRenderable,
                                           "isSmooth": model.get(i).isSmooth,
                                           "transparency": model.get(i).transparency
                                       })
    }
}

function addLayer(name, type, effectsModel, layersModel, overlayModel, index) {
    if (type === 'buttonDark') {
        const effect = JSON.parse(JSON.stringify(effectsModel.get(index)))
        const dropdowns = modelFunctions.getDropDowns()
        if (!Object.values(dropdowns).includes(name)) {
            effect.activated = true
        } else if (name === dropdowns.mask) {
            const blends = modelFunctions.combinationModes
            dropdownPopulation(blends, layersModel.count, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === dropdowns.overlay) {
            const blends = modelFunctions.overlayModes
            dropdownPopulation(blends, layersModel.count, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === dropdowns.colorSwap) {
            const options = modelFunctions.colorPresets
            dropdownPopulation(options, layersModel.count, effect, 'Red channel')
            dropdownPopulation(options, layersModel.count, effect, 'Green channel')
            dropdownPopulation(options, layersModel.count, effect, 'Blue channel')
            dropdownPopulation(options, layersModel.count, effect, 'Alpha channel')
            effect.activated = true
        } else if (name === dropdowns.saturation) {
            const options = modelFunctions.toneModes
            dropdownPopulation(options, layersModel.count, effect, 'Tone:')
            effect.activated = true
        } else if (name === dropdowns.blackAndWhite) {
            const options = modelFunctions.toneModes
            dropdownPopulation(options, layersModel.count, effect, 'Tone:')
            effect.activated = true
        } else if (name === dropdowns.colorHighlight) {
            const options = modelFunctions.colorChannels
            dropdownPopulation(options, layersModel.count, effect, 'Mode:')
            effect.activated = true
        } else if (name === dropdowns.rotation) {
            const options = modelFunctions.axisList
            dropdownPopulation(options, layersModel.count, effect, 'Rotating axis:')
            effect.activated = true
        }
        layersModel.append(Object.assign(effect, {
                                             "isRenderable": true,
                                             "isSmooth": false,
                                             "transparency": 0,
                                             "idx": layersModel.count,
                                             "overlay": false
                                         }))
        const effectProps = {
            "type": "buttonLayers",
            "wdth": 240,
            "val1": 0,
            "val2": 0
        }
        layersBlockModel.get(1).block.append(Object.assign(effect, effectProps))
        canvaFunctions.layersModelUpdate('', -1, layersModel.count - 1, 0)
    }
    console.log("layers", JSON.stringify(layersBlockModel.get(1)))
}

function chooseLayer(type, layersModel, propertiesModel, overlayModel, canvaFunctions, index, getEffectsBlockState, setEffectsBlockState, getLayerIndex, setLayerIndex) {
    const effectsBlockState = getEffectsBlockState()
    const filler = {
        "name": "",
        "type": "empty",
        "category": ""
    }
    let layer
    if (type === "buttonLayers" && !["insertion", "insertion2"].includes(effectsBlockState)) {
        propertiesUpdate(propertiesModel, layersModel, index, canvaFunctions)
        setEffectsBlockState("enabled")
        setLayerIndex(index)
        const preview = getPreview()
        if (preview) canvaFunctions.setHelperImage(index)
        else canvaFunctions.disableHelper()
    } else if (type === "buttonLayers" && ["insertion", "insertion2"].includes(effectsBlockState)) {
        let i = 0
        let overlayIndex = overlayModel.getModel(getLayerIndex(), getIterationIndex(), 'index')
        const layerProps = {
            "idx": getLayerIndex(),
            "iteration": getIterationIndex(),
            "overlay": true,
            "activated": false
        }
        layer = Object.assign(JSON.parse(JSON.stringify(layersModel.get(index))), layerProps)
        layer.items = [
                    {
                        "bval1": 0,
                        "bval2": 0,
                        "val1": index,
                        "val2": 0,
                        "max1": 1,
                        "max2": 1,
                        "min1": 0,
                        "min2": 0,
                        "name": "Open link",
                        "wdth": 230,
                        "view": "normal,overlay",
                        "type": "buttonDark",
                        "category": "layer"
                    }
                ]
        for (i = 0; i < 3; ++i) {
            layer.items.push(filler)
        }
        if (overlayIndex.length === 0) {
            overlayModel.append(layer)
        } else {
            overlayModel.set(overlayIndex[0], layer)
        }
        setEffectsBlockState("enabled")
        window.modelFunctions.autoSave()
        setIterationIndex(-1)
    }
}

function propertiesUpdate(propertiesModel, layersModel, index, canvaFunctions) {
    let i = 0
    propertiesModel.clear()
    canvaFunctions.disableManipulator()
    const newModel = {
        "isRenderable": layersModel.get(index).isRenderable,
        "isSmooth": layersModel.get(index).isSmooth,
        "transparency": layersModel.get(index).transparency,
        "nickname": layersModel.get(index).nickname,
        "items": []
    }
    for (; i < layersModel.get(index).items.count; ++i) {
        const item = JSON.parse(JSON.stringify(layersModel.get(index).items.get(i)))
        item.idx = index
        newModel.items.push(item)
    }
    propertiesModel.append(newModel)
}

function addOverlayEffect(state, effectsModel, overlayModel, index, insertionIndex, iterationIndex = -1) {
    console.log('Added overlay effect')
    let overlayIndex = -1
    const iterIndex = iterationIndex === -1 ? getIterationIndex() : iterationIndex
    let i = 0
    for (; i < overlayModel.count; ++i) {
        if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === iterIndex) {
            overlayIndex = i
        }
    }
    const effectProps = {
        "idx": insertionIndex,
        "iteration": iterIndex,
        "overlay": state === "insertion",
        "activated": false
    }
    const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(index))), effectProps)
    console.log('eff', JSON.stringify(effect))
    for (i = 0; i < effect.items.length; ++i) {
        effect.items[i].wdth = 230
    }
    if (overlayIndex === -1) {
        overlayModel.append(effect)
    } else {
        overlayModel.set(overlayIndex, effect)
    }
    console.log(JSON.stringify(overlayModel.get(overlayModel.count-1)))

    setIterationIndex(-1)
    return "enabled"
}

function addOverlayLayer(state, effectsModel, overlayModel, index, insertionIndex, iterationIndex = -1) {
    let overlayIndex = -1
    const iterIndex = iterationIndex === -1 ? getIterationIndex() : iterationIndex
    let i = 0
    for (; i < overlayModel.count; ++i) {
        if (overlayModel.get(i).idx === insertionIndex && overlayModel.get(i).iteration === iterIndex) {
            overlayIndex = i
        }
    }
    const effectProps = {
        "idx": insertionIndex,
        "iteration": iterIndex,
        "overlay": state === "insertion",
        "activated": false
    }
    const effect = Object.assign(JSON.parse(JSON.stringify(effectsModel.get(index))), effectProps)
    if (overlayIndex === -1) {
        overlayModel.append(effect)
    } else {
        overlayModel.set(overlayIndex, effect)
    }
    setIterationIndex(-1)
    return "enabled"
}

function removeReplacers() {
    if (layersModel.count < layersBlockModel.get(1).block.count) {
        for (let i = layersModel.count * 2; i >= 0; --i) {
            if (layersBlockModel.get(1).block.get(i).type === "buttonReplace" || layersBlockModel.get(1).block.get(i).type === "empty") {
                layersBlockModel.get(1).block.remove(i)
            }
        }
    }
}

function populateReplacers() {
    const length = layersModel.count
    const obj = {
        "type": "buttonReplace",
        "wdth": 240,
        "name": "",
        "nickname": "",
        "val1": 0,
        "val2": 0,
        "idx": -1,
        "isRenderable": true,
        "isSmooth": false,
        "transparency": 0
    }
    for (let i = 0; i <= length; ++i) {
        const newObj = Object.assign({}, obj)
        if (i === layerIndex || i === layerIndex + 1) {
            newObj.type = "empty"
        }
        newObj.idx = i
        layersBlockModel.get(1).block.insert(i * 2, newObj)
    }
}

function swapLayers(model, blockModel, overlayEffectsModel, index1, index2) {
    let isSwappable = true
    let i = 0
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        console.log("Swapping", index1, index2, overlayEffectsModel.get(i).idx
                    , overlayEffectsModel.get(i).items.get(0).name
                    , overlayEffectsModel.get(i).items.get(0).val1, overlayEffectsModel.get(i).idx)
        if ((overlayEffectsModel.get(i).items.get(0).name === "Open link"
             && overlayEffectsModel.get(i).items.get(0).val1 >= index2
             && overlayEffectsModel.get(i).idx <= index1) ||
                (overlayEffectsModel.get(i).items.get(0).name === "Open link"
                 && overlayEffectsModel.get(i).items.get(0).val1 >= index1
                 && overlayEffectsModel.get(i).idx <= index2)
                ) {
            isSwappable = false
            break
        }
    }
    if (!isSwappable) {
        const notificationText = "You can't swap layers because of linked layer"
        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        return false
    } else {
        removeReplacers()
        canvaFunctions.deactivateEffects(Math.min(index1, index2), false)
        const notificationText = "You can't swap non-existent layer"
        if (!!model.get(index1)) {
            const item = JSON.parse(JSON.stringify(model.get(index1)))
        } else {
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return false
        }
        if (!!model.get(index2)) {
            const item2 = JSON.parse(JSON.stringify(model.get(index2)))
        } else {
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
            return false
        }
        item.idx = index2
        item2.idx = index1
        const overlayItemsIndex1 = overlayEffectsModel.getModel(index1, -1, 'index')
        const overlayItemsIndex2 = overlayEffectsModel.getModel(index2, -1, 'index')
        const overlayLinkIndices1 = []
        const overlayLinkIndices2 = []
        model.set(index1, item2)
        model.set(index2, item)
        console.log(overlayItemsIndex1, overlayItemsIndex2)
        for (i = 0; i < overlayItemsIndex1.length; ++i) {
            overlayEffectsModel.setProperty(overlayItemsIndex1[i], 'idx', index2)
        }
        for (i = 0; i < overlayItemsIndex2.length; ++i) {
            overlayEffectsModel.setProperty(overlayItemsIndex2[i], 'idx', index1)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            if (overlayEffectsModel.get(i).items.get(0).name === "Open link") {
                if (overlayEffectsModel.get(i).items.get(0).val1 === index1) {
                    overlayLinkIndices1.push(i)
                } else if (overlayEffectsModel.get(i).items.get(0).val1 === index2) {
                    overlayLinkIndices2.push(i)
                }
            }
        }
        for (i = 0; i < overlayLinkIndices1.length; ++i) {
            overlayEffectsModel.get(overlayLinkIndices1[i]).items.setProperty(0, "val1", index2)
        }
        for (i = 0; i < overlayLinkIndices2.length; ++i) {
            overlayEffectsModel.get(overlayLinkIndices2[i]).items.setProperty(0, "val1", index1)
        }
        blockModel.get(1).block.set(
                    index1, item2
                    )
        blockModel.get(1).block.set(
                    index2, item
                    )
        if (layersModel.count > 0) canvaFunctions.layersModelUpdate('', 0, Math.min(index1, index2))
        return true
    }
}

function switchState({
                     spacer,
                     parent,
                     setState,
                     getState,
                     canvaFunctions,
                     exportMenuModel,
                     exportMenuBlockModel,
                     settingsMenuBlockModel,
                     settingsMenuModel
                     }) {
    const state = getState()
    if (state === "export") {
        close(spacer, parent, setState)
    } else if (state === "default") {
        open(spacer, parent, canvaFunctions, exportMenuModel, exportMenuBlockModel, settingsMenuBlockModel, settingsMenuModel, setState)
    }
}

function open(spacer,
              parent,
              canvaFunctions,
              exportMenuModel,
              exportMenuBlockModel,
              settingsMenuBlockModel,
              settingsMenuModel,
              setState) {
    spacer.spacerReset()
    spacer.y = (parent.height - spacer.height) / 2
    spacer.upperBlock = undefined
    spacer.lowerBlock = undefined
    const sizes = canvaFunctions.getBaseImageDims()
    exportMenuModel.set(0,
                        {
                            "val1": sizes.width,
                            "max1": sizes.sourceW > sizes.aspectW * 1.5 ? sizes.sourceW : sizes.aspectW * 1.5,
                            "min1": sizes.sourceW < sizes.aspectW / 1.5 ? sizes.sourceW : sizes.aspectW / 1.5
                        }
                        )
    exportMenuModel.set(1,
                        {
                            "val1": sizes.height,
                            "max1": sizes.sourceH > sizes.aspectH * 1.5 ? sizes.sourceH : sizes.aspectH * 1.5,
                            "min1": sizes.sourceH < sizes.aspectH / 1.5 ? sizes.sourceH : sizes.aspectH / 1.5
                        }
                        )
    let i = 0
    exportMenuBlockModel.set(1, {
                                 'block': []
                             })
    for (; i < exportMenuModel.count; ++i) {
        const item = Object.assign(exportMenuModel.get(i), { "wdth": 240 })
        exportMenuBlockModel.get(1).block.append(item)
    }
    populateSettings(settingsMenuBlockModel, settingsMenuModel)
    setState("export")
}

function populateSettings(settingsMenuBlockModel, settingsMenuModel) {
    updateSettingsBlock(settingsMenuModel, settingsMenuBlockModel, "settings")
    const settingsFile = `${baseDir}/settings.json`
    const data = fileIO.read(settingsFile)
    if (data !== "") {
        const jsonData = JSON.parse(data)
        for (let i = 0; i < jsonData.settings.length; ++i) {
            for (let j = 0; j < settingsMenuBlockModel.get(1).block.count; ++ j) {
                if (settingsMenuBlockModel.get(1).block.get(j).name === jsonData.settings[i].name) {
                    settingsMenuBlockModel.get(1).block.setProperty(j, 'val1', parseInt(jsonData.settings[i].val1))
                    break
                }
            }
        }
    }
}

function close(spacer, parent, setState) {
    spacer.spacerReset()
    spacer.y = (parent.height - spacer.height) / 2
    spacer.upperBlock = undefined
    spacer.lowerBlock = undefined
    setState("default")
}

function removeOverlayLayer({
                            layerIndex,
                            index,
                            value,
                            overlayEffectsModel,
                            layersModel,
                            manualLayerChoose,
                            rightPanelFunctions,
                            canvaFunctions
                            }) {
    const modelIndex = overlayEffectsModel.getModel(layerIndex, index, 'index')[0]
    if (typeof(modelIndex) === "undefined") overlayEffectsModel.append(value)
    else overlayEffectsModel.set(modelIndex, value)
    layersModel.setProperty(layerIndex, "activated", false)
    manualLayerChoose(layerIndex)
    rightPanelFunctions.propertiesBlockUpdate()
    canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
}

function layerRecovery({
                       layerIndex,
                       value,
                       canvaFunctions,
                       layersModel,
                       overlayEffectsModel,
                       manualLayerChoose,
                       rightPanelFunctions,
                       updateLayersBlockModel
                       }) {
    let i = layerIndex
    const overlayModel = value.overlayEffectsModel
    const layersModelValue = value.layersModel
    canvaFunctions.deactivateEffects(layerIndex, false)
    for (; i < layersModel.count; ++i) {
        layersModel.setProperty(i, "idx", i + 1)
    }
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        let idx = overlayEffectsModel.get(i).idx
        if (idx >= layerIndex) overlayEffectsModel.setProperty(i, "idx", idx + 1)
        if (overlayEffectsModel.get(i).items.get(0).name === "Open link") {
            idx = overlayEffectsModel.get(i).items.get(0).val1
            if (idx >= layerIndex) overlayEffectsModel.get(i).items.setProperty(0, "val1", idx + 1)
        }
    }
    for (i = 0; i < overlayModel.length; ++i) {
        overlayEffectsModel.insert(value.indices[i], overlayModel[i])
    }
    layersModel.insert(layerIndex, layersModelValue)
    const item = {
        "type": "buttonLayers",
        "wdth": 240,
        "val1": 0,
        "val2": 0
    }
    for (i = layerIndex; i < layersBlockModel.get(1).block.count; ++i) {
        layersBlockModel.get(1).block.setProperty(i, "idx", i + 1)
    }
    layersBlockModel.get(1).block.insert(layerIndex, Object.assign(layersModelValue, item))
    manualLayerChoose(layerIndex)
    rightPanelFunctions.propertiesBlockUpdate()
    canvaFunctions.setHelperImage(-1)
    canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
}

function removeLayer({
                     index1,
                     logging,
                     logRemove,
                     layersModel,
                     overlayEffectsModel,
                     canvaFunctions,
                     modelFunctions,
                     leftPanelFunctions,
                     rightPanelFunctions,
                     updateLayersBlockModel
                     }) {
    const index = layersBlockModel.get(1).block.get(index1).idx
    leftPanelFunctions.removeReplacers()
    if (logging) logRemove(index)
    let i = index + 1
    const overlayIndices = []
    const linkIndices = []
    canvaFunctions.deactivateEffects(index, false)
    canvaFunctions.setHelperImage(-1)
    canvaFunctions.srcListRemove(index, 0)
    canvaFunctions.disableManipulator()
    setIterationIndex(-1)
    for (; i < layersModel.count; ++i) {
        layersModel.setProperty(i, "idx", i - 1)
    }
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        let idx = overlayEffectsModel.get(i).idx
        if (idx > index) overlayEffectsModel.setProperty(i, "idx", idx - 1)
        else if (idx === index) overlayIndices.push(i)
        if (overlayEffectsModel.get(i).items.count > 0 && overlayEffectsModel.get(i).items.get(0).name === "Open link") {
            idx = overlayEffectsModel.get(i).items.get(0).val1
            if (idx > index) overlayEffectsModel.get(i).items.setProperty(0, "val1", idx - 1)
            else if (idx === index) overlayIndices.push(i)
        }
    }
    layersModel.remove(index)
    for (i = index + 1; i < layersBlockModel.get(1).block.count; ++i) {
        layersBlockModel.get(1).block.setProperty(i, "idx", i - 1)
    }
    layersBlockModel.get(1).block.remove(index)

    for (i = 0; i < overlayIndices.length; ++i) {
        overlayEffectsModel.remove(overlayIndices[i] - i)
    }
    if (logging) window.modelFunctions.autoSave()
    if (layersModel.count > 0) {
        console.log('idx', index)
        canvaFunctions.layersModelUpdate('', 0, Math.max(0, index - 1), 0)
        canvaFunctions.assignFinalImage(Math.max(0, index - 1))
    }
    rightPanelFunctions.resetPropertiesBlock()
}

function switchRendering({
                         index,
                         isRenderable,
                         layersModel,
                         canvaFunctions
                         }) {
    layersModel.setProperty(index, 'isRenderable', !isRenderable)
    canvaFunctions.layersModelUpdate('', -1, index, 0)
}

function switchSmoothing({
                         index,
                         isSmooth,
                         layersModel,
                         canvaFunctions
                         }) {
    layersModel.setProperty(index, 'isSmooth', !isSmooth)
    canvaFunctions.layersModelUpdate('', -1, index, 0)
}

function setLayerTransparency({
                         index,
                         transparency,
                         layersModel,
                         canvaFunctions
                         }) {
    console.log('Set transparency to', transparency)
    layersModel.setProperty(index, 'transparency', transparency)
    canvaFunctions.layersModelUpdate('', -1, index, 0)
}

function setValue({
                  index,
                  subIndex,
                  propIndex,
                  valIndex,
                  value,
                  name,
                  layersModel,
                  manualLayerChoose,
                  rightPanelFunctions,
                  updateLayersBlockModel,
                  canvaFunctions,
                  overlayEffectsModel
                  }) {
    let propertiesBlockModel
    let propertiesModel
    let i
    if (name.includes("Visible")) {
        const layerIndex = getLayerIndex()
        layersModel.setProperty(index, "isRenderable", value === 1)
        layersBlockModel.get(1).block.setProperty(index, 'isRenderable', value === 1)
        if (layerIndex === index) {
            propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(0).block
            propertiesModel = rightPanelFunctions.getPropertiesModel()
            for (i = 0; i < propertiesBlockModel.count; ++i) {
                if (propertiesBlockModel.get(i).name === "Visible") {
                    propertiesBlockModel.setProperty(i, "val1", value ? 1 : 0)
                }
            }
            propertiesModel.setProperty(0, "isRenderable", value === 1)
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else if (name.includes("Inversion")) {
        layersModel.get(index).items.setProperty(subIndex, `val${valIndex+1}`, value)
        if (getLayerIndex() === index) {
            propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
            propertiesBlockModel.setProperty(subIndex, `val${valIndex+1}`, value)
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else if (name.includes("Smoothing")) {
        const layerIndex = getLayerIndex()
        layersModel.setProperty(index, "isSmooth", value === 1)
        layersBlockModel.get(1).block.setProperty(index, 'isSmooth', value === 1)
        if (layerIndex === index) {
            propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(0).block
            propertiesModel = rightPanelFunctions.getPropertiesModel()
            for (i = 0; i < propertiesBlockModel.count; ++i) {
                if (propertiesBlockModel.get(i).name === "Smoothing") {
                    propertiesBlockModel.setProperty(i, "val1", value)
                }
            }
            propertiesModel.setProperty(0, "isSmooth", value)
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else if (name.includes("Transparency")) {
        const layerIndex = getLayerIndex()
        layersModel.setProperty(index, "transparency", value)
        layersBlockModel.get(1).block.setProperty(index, 'transparency', value)
        if (layerIndex === index) {
            propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(0).block
            propertiesModel = rightPanelFunctions.getPropertiesModel()
            for (i = 0; i < propertiesBlockModel.count; ++i) {
                if (propertiesBlockModel.get(i).name === "Transparency") {
                    propertiesBlockModel.setProperty(i, "val1", value)
                }
            }
            propertiesModel.setProperty(0, "transparency", value)
        }
        canvaFunctions.layersModelUpdate('', -1, index, valIndex)
    } else if (name.includes("Renamed")) {
        leftPanelFunctions.renamingLayer(index, value)
    } else {
        if (subIndex === -1) {
            layersModel.get(index).items.setProperty(propIndex, `val${valIndex+1}`, value)
            if (getLayerIndex() === index) {
                propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
                propertiesModel = rightPanelFunctions.getPropertiesModel()
                propertiesBlockModel.setProperty(propIndex, `val${valIndex+1}`, value)
                propertiesModel.get(0).items.setProperty(propIndex, `val${valIndex+1}`, value)
            }
            canvaFunctions.layersModelUpdate('', -1, index, valIndex)
        } else {
            const overlayIndex = overlayEffectsModel.getModel(index, subIndex, 'index')[0]
            overlayEffectsModel.get(overlayIndex).items.setProperty(propIndex, `val${valIndex+1}`, value)
            canvaFunctions.layersModelUpdate('', -1, index, valIndex)
        }
    }
}

function setBlendingMode({
                         index,
                         subIndex,
                         valIndex,
                         value,
                         layersModel,
                         manualLayerChoose,
                         rightPanelFunctions,
                         canvaFunctions
                         }) {
    layersModel.get(index).items.setProperty(subIndex, `val${valIndex+1}`, value)
    if (getLayerIndex() === index) {
        const names = [layersModel.get(index).items.get(subIndex).name, overlayEffectsModel.getModel(index, subIndex)[0].items.get(value).name]
        const name = `${names[0].substring(0, names[0].indexOf(":") + 1)} ${names[1]}`
        const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel().get(1).block
        propertiesBlockModel.setProperty(subIndex, `val${valIndex+1}`, value)
        propertiesBlockModel.setProperty(subIndex, `name`, name)
    }
    canvaFunctions.layersModelUpdate('', -1, index, valIndex)
}

function logRemove({
                   index,
                   actionsLog,
                   getStepIndex,
                   setStepIndex,
                   layersModel,
                   overlayEffectsModel
                   }) {
    const stepIndex = getStepIndex()

    const overlayLinksModel = []
    const overlayLinksIndices = []
    for (let i = 0; i < overlayEffectsModel.count; ++i) {
        if (overlayEffectsModel.get(i).idx === index) {
            overlayLinksModel.push(overlayEffectsModel.get(i))
            overlayLinksIndices.push(i)
        }
        else if (overlayEffectsModel.get(i).items.get(0).name === "Open link" && overlayEffectsModel.get(i).items.get(0).val1 === index) {
            overlayLinksModel.push(overlayEffectsModel.get(i))
            overlayLinksIndices.push(i)
        }
    }

    actionsLog.trimModel(stepIndex)
    actionsLog.append({
                          "block": 'Layers',
                          "name": `Removed effect ${layersModel.get(index).name} at ${index}`,
                          "prevValue": {
                              "layersModel": JSON.parse(JSON.stringify(layersModel.get(index))),
                              "overlayEffectsModel": JSON.parse(JSON.stringify(overlayLinksModel)),
                              "indices": overlayLinksIndices
                          },
                          "value": {},
                          "index": index, // layer number
                          "subIndex": -1, // sublayer number
                          "propIndex": -1, // sublayer property number
                          "valIndex": -1
                      })
    setStepIndex(stepIndex + 1)
    actionsLog.historyBlockModelGeneration()
}

function overlayToLink(idx, index) {
    const linksIndices = []
    let isMovable = false
    let i
    let j
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        for (j = 0; j < overlayEffectsModel.get(i).items.count; ++j) {
            if (overlayEffectsModel.get(i).items.get(j).name === "Open link" && overlayEffectsModel.get(i).idx === idx) {
                linksIndices.push({ i, j })
            }
        }
    }
    for (i = 0; i < linksIndices.length; ++i) {
        if (linksIndices[0].i !== i) {
            if (overlayEffectsModel.get(linksIndices[i].i).items.get(linksIndices[i].j).val1 >= Math.min(index, idx)
                    && overlayEffectsModel.get(linksIndices[i].i).items.get(linksIndices[i].j).val1 < Math.max(index, idx)
                    ) {
                isMovable = true
                break
            }
        }
    }
    return isMovable
}

function moveLayer(idx, index1, logging) {
    let i
    let j
    let isMovable = true
    let index = index1
    const layer = JSON.parse(JSON.stringify(layersModel.get(idx)))
    for (i = 0; i < overlayEffectsModel.count; ++i) {
        for (j = 0; j < overlayEffectsModel.get(i).items.count; ++j) {
            if (overlayEffectsModel.get(i).items.get(j).name === "Open link") console.log(overlayEffectsModel.get(i).items.get(j).val1, overlayEffectsModel.get(i).idx, idx, index)
            if ((overlayEffectsModel.get(i).items.get(j).name === "Open link"
                 && (overlayEffectsModel.get(i).items.get(j).val1 === idx
                     && overlayEffectsModel.get(i).idx >= Math.min(index, idx)
                     && overlayEffectsModel.get(i).idx < Math.max(index, idx))) // forbid link movement after overlay with link
                    || overlayToLink(idx, index)) {
                isMovable = false
                break
            }
        }
    }
    if (isMovable) {
        layer.idx = index
        removeReplacers()
        const layerButton = JSON.parse(JSON.stringify(layersBlockModel.get(1).block.get(idx)))
        layerButton.idx = index
        if (index < idx) {
            for (i = 0; i < overlayEffectsModel.count; ++i) {
                if (overlayEffectsModel.get(i).idx === idx) {
                    overlayEffectsModel.setProperty(i, "idx", index)
                } else if (overlayEffectsModel.get(i).idx >= index && overlayEffectsModel.get(i).idx < idx) {
                    overlayEffectsModel.setProperty(i, "idx", overlayEffectsModel.get(i).idx + 1)
                }
                for (j = 0; j < overlayEffectsModel.get(i).items.count; ++j) {
                    if (overlayEffectsModel.get(i).items.get(j).name === "Open link" && overlayEffectsModel.get(i).items.get(j).val1 === idx) {
                        overlayEffectsModel.get(i).items.setProperty(j, "val1", index)
                    } else if (overlayEffectsModel.get(i).items.get(j).name === "Open link" && overlayEffectsModel.get(i).items.get(j).val1 >= index && overlayEffectsModel.get(i).items.get(j).val1 < idx) {
                        overlayEffectsModel.get(i).items.setProperty(j, "val1", overlayEffectsModel.get(i).items.get(j).val1 + 1)
                    }
                }
            }
            layersModel.remove(idx)
            layersBlockModel.get(1).block.remove(idx)
            for (i = index; i < idx; ++i) {
                layersModel.setProperty(i, "idx", i + 1)
                layersBlockModel.get(1).block.setProperty(i, "idx", i + 1)
            }
            layersModel.insert(index, layer)
            layersBlockModel.get(1).block.insert(index, layerButton)
        } else if (index > idx) {
            layersModel.insert(index, layer)
            layersBlockModel.get(1).block.insert(index, layerButton)
            for (i = idx; i <= index; ++i) {
                layersModel.setProperty(i, "idx", i - 1)
                layersBlockModel.get(1).block.setProperty(i, "idx", i - 1)
            }
            for (i = 0; i < overlayEffectsModel.count; ++i) {
                if (overlayEffectsModel.get(i).idx === idx) {
                    overlayEffectsModel.setProperty(i, "idx", index-1)
                } else if (overlayEffectsModel.get(i).idx < index && overlayEffectsModel.get(i).idx > idx) {
                    overlayEffectsModel.setProperty(i, "idx", overlayEffectsModel.get(i).idx - 1)
                }
                for (j = 0; j < overlayEffectsModel.get(i).items.count; ++j) {
                    if (overlayEffectsModel.get(i).items.get(j).name === "Open link" && overlayEffectsModel.get(i).items.get(j).val1 === idx) {
                        overlayEffectsModel.get(i).items.setProperty(j, "val1", index - 1)
                    } else if (overlayEffectsModel.get(i).items.get(j).name === "Open link" && overlayEffectsModel.get(i).items.get(j).val1 < index && overlayEffectsModel.get(i).items.get(j).val1 > idx) {
                        overlayEffectsModel.get(i).items.setProperty(j, "val1", overlayEffectsModel.get(i).items.get(j).val1 - 1)
                    }
                }
            }
            layersModel.remove(idx)            
            layersBlockModel.get(1).block.remove(idx)
            index -= 1
        }
        setLayerIndex(index)
        manualLayerChoose(index)
        rightPanelFunctions.propertiesBlockUpdate()
        canvaFunctions.layersModelUpdate('', -1, Math.min(index, idx))
        if (logging) {
            actionsLog.trimModel(stepIndex)
            actionsLog.append({
                                  "block": 'Layers',
                                  "name": `Moved layer ${layer.name} to ${index1}`,
                                  "prevValue": {
                                      "val": idx// > index ? idx + 1 : idx
                                  },
                                  "value": {
                                      "val": index1
                                  },
                                  "index": idx, // layer number
                                  "subIndex": -1, // sublayer number
                                  "propIndex": -1, // sublayer property number
                                  "valIndex": -1
                              })
            setStepIndex(stepIndex + 1)
            window.modelFunctions.autoSave()
            actionsLog.historyBlockModelGeneration()
        }
    } else {
        const notificationText = "You can't move layer with link upper than linked layer"
        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
    }
    return isMovable
}
