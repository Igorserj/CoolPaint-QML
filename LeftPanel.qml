import QtQuick 2.15
import "Controls"
import "Models"
import "Controllers/leftPanelController.js" as Controller

Rectangle {
    width: window.width / 1280 * 260
    height: window.height
    color: "#302430"
    Rectangle {
        color: "transparent"
        height: 0.5 * parent.height
        width: parent.width
        clip: true
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: effectsBlockModel
                delegate: Column {
                    Repeater {
                        model: block
                        delegate: Controls {
                            function controlsAction() {
                                Controller.addLayer(type, effectsModel, layersModel, index)
                                Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        color: "transparent"
        height: 0.5 * parent.height
        width: parent.width
        clip: true
        y: height
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: layersBlockModel
                delegate: Column {
                    Repeater {
                        model: block
                        delegate: Controls {
                            function controlsAction() {
                                Controller.chooseLayer(type, layersModel, rightPanel.propertiesModel, index)
                                rightPanel.propertiesBlockUpdate()
                            }
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        Controller.effectsBlockModelGeneration(effectsModel, effectsBlockModel)
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }

    EffectsBlockModel {
        id: effectsBlockModel
    }
    LayersBlockModel {
        id: layersBlockModel
    }
    function updateLayersBlockModel() {
        Controller.layersBlockModelGeneration(layersModel, layersBlockModel)
    }
    function removeLayer(index) {
        for (let i = index + 1; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "idx", i - 1)
        }
        canva.deactivateEffects(index)
        layersModel.remove(index)
        if (layersModel.count > 0) canva.layersModelUpdate('', 0, 0, index)
        rightPanel.resetPropertiesBlock()
        updateLayersBlockModel()
    }
}
