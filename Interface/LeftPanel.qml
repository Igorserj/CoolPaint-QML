import QtQuick 2.15
import Qt.labs.platform 1.1
import "../Controls"
import "../Models"
import "../Controllers/leftPanelController.js" as Controller
import "../Controllers/exportMenuController.js" as ExportController

Rectangle {
    property var controller: Controller
    property var effectsBlockItem
    property var layersBlockItem
    property int layerIndex: -1
    width: window.width / 1280 * 260
    height: window.height
    color: window.style.currentTheme.vinous
    state: "default"
    states: [
        State {
            name: "default"
            PropertyChanges {
                target: leftPanelLoader
                sourceComponent: effectsAndLayersComponent
            }
        },
        State {
            name: "export"
            PropertyChanges {
                target: leftPanelLoader
                sourceComponent: exportComponent
            }
        }
    ]
    Component.onCompleted: setLeftPanelFunctions()
    Loader {
        id: leftPanelLoader
        anchors.fill: parent
    }

    Component {
        id: effectsAndLayersComponent
        EffectsMenu {}
    }
    Component {
        id: exportComponent
        ExportMenu {}
    }
    Spacer {
        id: spacer
        y: (parent.height - height) / 2
    }

    EffectsBlockModel {
        id: effectsBlockModel
    }
    LayersBlockModel {
        id: layersBlockModel
    }
    FileDialog {
        id: exportFileDialog
        nameFilters: ["Joint Photographic Experts Group (*.jpeg)", /*"Digital Negative Specification (*.dng)", */"Tagged Image File Format (*.tiff)", "Portable Network Graphics (*.png)", "Bitmap Picture (*.bmp)"]
        fileMode: FileDialog.SaveFile
        selectedNameFilter.index: 0
        onAccepted: ExportController.exportDialogAccept(canvaFunctions.getFinalImage(), currentFile, selectedNameFilter.extensions)
    }
    ExportMenuBlockModel {id: exportMenuBlockModel}
    SettingsMenuBlockModel {id: settingsMenuBlockModel}

    function switchState() {
        const pattern = Object.assign(propsAndFuncsPattern(), { spacer, parent })
        Controller.switchState(pattern)
    }

    function removeOverlayLayer(layerIndex, index, value) {
        const pattern = Object.assign(propsAndFuncsPattern(), { layerIndex, index, value })
        Controller.removeOverlayLayer(pattern)
    }

    function layerRecovery(layerIndex, value) {
        const pattern = Object.assign(propsAndFuncsPattern(), { layerIndex, value })
        Controller.layerRecovery(pattern)
    }

    function removeLayer(index, logging = true) {
        const pattern = Object.assign(propsAndFuncsPattern(), { index, logging })
        Controller.removeLayer(pattern)
    }

    function switchRendering(index, isRenderable) {
        const pattern = Object.assign(propsAndFuncsPattern(), { index, isRenderable })
        Controller.switchRendering(pattern)
    }

    function setValue(index, subIndex, propIndex, valIndex, value, name) {
        const pattern = Object.assign(propsAndFuncsPattern(), { index, subIndex, propIndex, valIndex, value, name })
        Controller.setValue(pattern)
    }

    function setBlendingMode(index, subIndex, valIndex, value) {
        const pattern = Object.assign(propsAndFuncsPattern(), { index, subIndex, valIndex, value })
        Controller.setBlendingMode(pattern)
    }

    function setLayersOrder(prevValue, value) {
        Controller.swapLayers(layersModel, layersBlockModel, overlayEffectsModel, prevValue, value)
        setLayersBlockState("enabled")
    }

    function addLayer(index) {
        Controller.addLayer(effectsModel.get(index).name, "buttonDark", effectsModel, layersModel, overlayEffectsModel, index)
        setLayersBlockState("enabled")
    }

    function addOverlayEffect(layerIndex, index, iterationIndex) {
        setEffectsBlockState(Controller.addOverlayEffect("iteration", effectsModel, overlayEffectsModel, index, layerIndex, iterationIndex))
        manualLayerChoose(layerIndex)
        rightPanelFunctions.propertiesBlockUpdate()
        canvaFunctions.layersModelUpdate('', -1, layerIndex, 0)
    }

    function updateLayersBlockModel() {
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }

    function logRemove(index) {
        const pattern = Object.assign(propsAndFuncsPattern(), { index })
        Controller.logRemove(pattern)
    }

    function manualLayerChoose(index) {
        Controller.chooseLayer(
                    "buttonLayers",
                    layersModel,
                    rightPanelFunctions.getPropertiesModel(),
                    overlayEffectsModel,
                    canvaFunctions,
                    index,
                    getEffectsBlockState,
                    setEffectsBlockState,
                    getLayerIndex,
                    setLayerIndex
                    )
    }

    function getLayersBlockModel() {
        return layersBlockModel
    }

    function setLayerIndex(value) {
        if (!isNaN(parseInt(value)) && value >= -1) layerIndex = parseInt(value)
        else console.log(`Wrong value: ${value} for layer index`)
    }

    function getLayerIndex() {
        return layerIndex
    }

    function setEffectsBlockState(state = "") {
        if (typeof(effectsBlockItem) !== "undefined" && effectsBlockItem !== null) effectsBlockItem.state = state
    }

    function getEffectsBlockState() {
        if (typeof(effectsBlockItem) !== "undefined" && effectsBlockItem !== null) return effectsBlockItem.state
        else return "enabled"
    }

    function setLayersBlockState(state = "") {
        if (typeof(layersBlockItem) !== "undefined" && layersBlockItem !== null) layersBlockItem.state = state
    }

    function getState() {
        return state
    }

    function setState(newState) {
        state = newState
    }

    function close() {
        Controller.close(spacer, parent, setState)
    }

    function populateSettings() {
        Controller.populateSettings(settingsMenuBlockModel, settingsMenuModel)
    }

    function renamingLayer(index, value) {
        layersModel.setProperty(index, "nickname", value)
        layersBlockModel.get(1).block.setProperty(index, "nickname", value)
        const propertiesBlockModel = rightPanelFunctions.getPropertiesBlockModel()
        if (index === layerIndex) {
            for (let i = 0; i < propertiesBlockModel.get(0).block.count; ++i) {
                if (propertiesBlockModel.get(0).block.get(i).name.includes("Alias")) {
                    propertiesBlockModel.get(0).block.setProperty(i, "name", `Alias ${value}`)
                }
            }
        }
    }
    function dropdownPopulation(blends, idx, effect, name) {
        let iteration = -1
        for (let i = 0; i < effect.items.length; ++i) {
            if (effect.items[i].name === name) {
                iteration = i
                break
            }
        }
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
            "wdth": 230,
            "type": "buttonDark",
            "category": "layer"
        }
        const items = blends.map((blendName) => {
                                     const it = JSON.parse(JSON.stringify(item))
                                     it.name = blendName
                                     return it
                                 })
        const obj = {
            "isOverlay": false,
            "name": `${name}: ${blends[0]}`,
            "overlay": false,
            "activated": false,
            idx,
            iteration
        }
        obj.items = items
        overlayEffectsModel.append(obj)
    }

    function replacingLayer(idx, effectIndex) {
        const overlayIndices = overlayEffectsModel.getModel(idx, -1, "index")
        for (let i = 0; i < overlayIndices.length; ++i) {
            overlayEffectsModel.remove(overlayIndices[i] - i)
        }
        const effect = JSON.parse(JSON.stringify(effectsModel.get(effectIndex)))
        const name = effect.name
        if (!['Overlay', 'Combination mask', 'Color swap', 'Saturation'].includes(name)) {
            effect.activated = true
        } else if (name === 'Combination mask') {
            const blends = ['Combination', 'Union', 'Subtract', 'Intersection', 'Symmetric Difference']
            dropdownPopulation(blends, idx, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === 'Overlay') {
            const blends = ['Normal', 'Addition', 'Subtract', 'Difference', 'Multiply', 'Divide', 'Darken Only', 'Lighten Only', 'Dissolve', 'Smooth Dissolve', 'Screen', 'Overlay', 'Hard Light', 'Soft Light', 'Color Dodge', 'Color Burn', 'Linear Burn', 'Vivid Light', 'Linear Light', 'Hard Mix']
            dropdownPopulation(blends, idx, effect, 'Blending mode:')
            effect.activated = false
        } else if (name === 'Color swap') {
            const options = ['Red', 'Green', 'Blue', 'Alpha', 'Null', 'Blank']
            dropdownPopulation(options, idx, effect, 'Red channel')
            dropdownPopulation(options, idx, effect, 'Green channel')
            dropdownPopulation(options, idx, effect, 'Blue channel')
            dropdownPopulation(options, idx, effect, 'Alpha channel')
            effect.activated = true
        } else if (name === 'Saturation') {
            const options = ['Average', 'Medium', 'Light', 'Dark', 'Saddle point']
            dropdownPopulation(options, idx, effect, 'Tone:')
            effect.activated = true
        }
        effect.isRenderable = true
        effect.idx = idx
        effect.overlay = false
        layersModel.set(idx, effect)

        layersBlockModel.get(1).block.set(idx, Object.assign({
                                           "type": "buttonLayers",
                                           "wdth": 240,
                                           "val1": 0,
                                           "val2": 0
                                       }, effect))
        manualLayerChoose(idx)
        rightPanelFunctions.propertiesBlockUpdate()
        canvaFunctions.layersModelUpdate('', -1, idx, 0)
    }

    function propsAndFuncsPattern() {
        return {
            canvaFunctions,
            exportMenuModel,
            exportMenuBlockModel,
            settingsMenuBlockModel,
            settingsMenuModel,
            overlayEffectsModel,
            layersModel,
            manualLayerChoose,
            rightPanelFunctions,
            updateLayersBlockModel,
            logRemove,
            modelFunctions,
            leftPanelFunctions,
            setState,
            getState,
            setStepIndex,
            getStepIndex,
            actionsLog
        }
    }

    function setLeftPanelFunctions() {
        leftPanelFunctions = {
            getEffectsBlockState,
            setEffectsBlockState,
            updateLayersBlockModel,
            getLayersBlockModel,
            removeLayer,
            removeOverlayLayer,
            layerRecovery,
            setValue,
            setBlendingMode,
            setLayersOrder,
            addLayer,
            addOverlayEffect,
            getLayerIndex,
            setLayerIndex,
            setLayersBlockState,
            switchState,
            manualLayerChoose,
            switchRendering,
            populateSettings,
            getState,
            setState,
            renamingLayer,
            replacingLayer
        }
    }
}
