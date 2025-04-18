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
    color: "#302430"
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
        onAccepted: ExportController.exportDialogAccept(canva.finalImage, currentFile, selectedNameFilter.extensions)
    }
    ExportMenuBlockModel {id: exportMenuBlockModel}
    StyleSheet {id: style}

    function switchState() {
        if (state === "export") {
            close()
        } else if (state === "default") {
            open()
        }
    }
    function open() {
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        const sizes = canva.getBaseImageDims()
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
        exportMenuBlockModel.set(1, {
                                     'block': []
                                 })
        for (let i = 0; i < exportMenuModel.count; ++i) {
            exportMenuBlockModel.get(1).block.append(exportMenuModel.get(i))
        }
        state = "export"
    }
    function close() {
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "default"
    }

    function updateLayersBlockModel() {
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }
    function manualLayerChoose(index) {
        Controller.chooseLayer("buttonLayers", layersModel, rightPanel.propertiesModel, index, setEffectsBlockState)
    }
    function addLayer(index) {
        Controller.addLayer(effectsModel.get(index).name, "buttonDark", effectsModel, layersModel, index)
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
        setLayersBlockState("enabled")
    }
    function removeOverlayLayer(layerIndex, index, value) {
        const modelIndex = overlayEffectsModel.getModel(layerIndex, index, 'index')[0]
        overlayEffectsModel.set(modelIndex, value)
        manualLayerChoose(layerIndex)
        rightPanel.propertiesBlockUpdate()
        canva.layersModelUpdate('', -1, layerIndex, 0)
    }
    function addOverlayLayer(layerIndex, index, state) {
        setEffectsBlockState(Controller.addOverlayLayer(state, effectsModel, overlayEffectsModel, index, layerIndex))
        rightPanel.propertiesBlockUpdate()
        canva.layersModelUpdate('', -1, layerIndex, 0)
    }
    function layerRecovery(layerIndex, value) {
        let i = layerIndex
        const overlayModel = value.overlayEffectsModel
        const overlayIndices = []
        for (; i < layersModel.count; ++i) {
            const modelIndices = overlayEffectsModel.getModel(i, -1, 'index')
            layersModel.setProperty(i, "idx", i + 1)
            overlayEffectsModel.setProperty(modelIndices[0], 'idx', overlayEffectsModel.get(modelIndices[0]).idx + 1)
            overlayEffectsModel.setProperty(modelIndices[1], 'idx', overlayEffectsModel.get(modelIndices[1]).idx + 1)
        }
        for (i = 0; i < overlayModel.length; ++i) {
            overlayEffectsModel.insert(value.indices[i], overlayModel[i])
        }
        layersModel.insert(layerIndex, value.layersModel)
        manualLayerChoose(layerIndex)
        rightPanel.propertiesBlockUpdate()
        canva.layersModelUpdate('', -1, 0, 0)
        updateLayersBlockModel()
    }
    function removeLayer(index, logging = true) {
        if (logging) logRemove(index)
        let i = index + 1
        const overlayIndices = []
        for (; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "idx", i - 1)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            const idx = overlayEffectsModel.get(i).idx
            if (idx > index) overlayEffectsModel.setProperty(i, "idx", idx - 1)
            else if (idx === index) overlayIndices.push(i)
        }
        canva.deactivateEffects(index)
        layersModel.remove(index)
        for (i = 0; i < overlayIndices.length; ++i) {
            overlayEffectsModel.remove(overlayIndices[i] - i)
        }
        if (layersModel.count > 0) canva.layersModelUpdate('', 0, 0, index)
        rightPanel.resetPropertiesBlock()
        updateLayersBlockModel()
    }
    function setValue(index, subIndex, propIndex, valIndex, value) {
        if (subIndex === -1) {
            console.log(`Setting propIndex val${valIndex+1} to ${value}`)
            layersModel.get(index).items.setProperty(propIndex, `val${valIndex+1}`, value)
            manualLayerChoose(index)
            rightPanel.propertiesBlockUpdate()
            canva.layersModelUpdate('', -1, index, valIndex)
        } else {
            const overlayIndex = overlayEffectsModel.getModel(index, subIndex, 'index')[0]
            overlayEffectsModel.get(overlayIndex).items.setProperty(propIndex, `val${valIndex+1}`, value)
            manualLayerChoose(index)
            rightPanel.propertiesBlockUpdate()
            canva.layersModelUpdate('', -1, index, valIndex)
        }
    }
    function setLayersOrder(prevValue, value) {
        Controller.swapLayers(layersModel, layersBlockModel, overlayEffectsModel, prevValue, value)
    }
    function logRemove(index) {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: 'Layers',
                              name: `Removed effect ${layersModel.get(index).name} at ${index}`,
                              prevValue: {
                                  layersModel: JSON.parse(JSON.stringify(layersModel.get(index))),
                                  overlayEffectsModel: JSON.parse(JSON.stringify(overlayEffectsModel.getModel(index, -1, 'default'))),
                                  indices: overlayEffectsModel.getModel(index, -1, 'index')
                              },
                              value: {},
                              index: index, // layer number
                              subIndex: -1, // sublayer number
                              propIndex: -1, // sublayer property number
                              valIndex: -1
                          })
        stepIndex += 1
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
    function getLayersBlockState() {
        if (typeof(layersBlockItem) !== "undefined" && layersBlockItem !== null) return layersBlockItem.state
        else return "enabled"
    }
}
