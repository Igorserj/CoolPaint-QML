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
    color: style.currentTheme.vinous
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
    StyleSheet {id: style}

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
    }

    function addLayer(index) {
        Controller.addLayer(effectsModel.get(index).name, "buttonDark", effectsModel, layersModel, overlayEffectsModel, index)
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
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
            switchRendering
        }
    }
}
