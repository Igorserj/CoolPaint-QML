import QtQuick 2.15
import "../Controllers/effectsController.js" as Controller

Item {
    property alias layersRepeater: layersRepeater
    property var controller: Controller
    width: baseImage.paintedWidth
    height: baseImage.paintedHeight
    Component.onCompleted: setCanvaFunctions()
    Repeater {
        id: layersRepeater
        model: layersModel
        delegate: Item {
            width: parent.width
            height: parent.height
            visible: index === layersModel.count - 1
            Loader {
                property var itemList: items
                property int layerIndex: index
                property bool overLay: overlay
                asynchronous: true
                width: parent.width
                height: parent.height
                visible: false
                active: activated
                sourceComponent: Controller.addEffect(name)
                onLoaded: Controller.setImage(this, img, img3, isRenderable, index, parent.visible)
            }
            Image {
                id: img
                width: parent.width
                height: parent.height
                smooth: smoothing
                x: baseImage.x
                y: baseImage.y
                visible: true
                Component.onCompleted: {
                    if (index === layersModel.count - 1) {
                        scale = Qt.binding(() => scaling)
                        mirror = Qt.binding(() => mirroring)
                        finalImage = this
                    }
                }
            }
            Image {
                id: img3
                width: parent.width
                height: parent.height
                smooth: smoothing
                visible: false
                onSourceChanged: {
                    Controller.reActivateLoader(layersModel, overlayEffectsModel, index)
                    srcListAppend(source, index, 0)
                    if (index === leftPanelFunctions.getLayerIndex()) {
                        helperImage.source = Qt.binding(() => source)
                    }
                }
            }
        }
    }
    Repeater {
        id: overlaysRepeater
        model: overlayEffectsModel
        delegate: Item {
            width: parent.width
            height: parent.height
            visible: false
            Loader {
                property var itemList: items
                property int layerIndex: idx
                property bool overLay: overlay
                asynchronous: true
                width: parent.width
                height: parent.height
                visible: false
                active: activated
                sourceComponent: Controller.addEffect(name)
                onLoaded: Controller.setImage(this, img2, undefined, true, index, false)
            }
            Image {
                id: img2
                width: parent.width
                height: parent.height
                smooth: smoothing
                x: (baseImage.width - width) / 2
                y: (baseImage.height - height) / 2
                visible: false
                onSourceChanged: {
                    Controller.reActivateLayer(layersModel, overlayEffectsModel, idx, iteration, finalImage)
                }
            }
        }
    }
    Component {
        id: colorShift
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property point imageRShift: Controller.propertyPopulation("two", itemList, 0)
            readonly property point imageGShift: Controller.propertyPopulation("two", itemList, 1)
            readonly property point imageBShift: Controller.propertyPopulation("two", itemList, 2)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorShift.fsh"
        }
    }
    Component {
        id: vignette
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double upperRange: Controller.propertyPopulation("one", itemList, 0)
            readonly property double lowerRange: Controller.propertyPopulation("one", itemList, 1)
            readonly property point center: Controller.propertyPopulation("two", itemList, 2)
            readonly property double roundness: Controller.propertyPopulation("one", itemList, 3)
            readonly property double aspect: parent.width / parent.height
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/vignette.fsh"
        }
    }
    Component {
        id: saturation
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property point strength: Controller.propertyPopulation("two", itemList, 0)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/saturation.fsh"
        }
    }
    Component {
        id: grain
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double density: Controller.propertyPopulation("one", itemList, 0)
            readonly property double lowerRange: Controller.propertyPopulation("one", itemList, 1)
            readonly property double upperRange: Controller.propertyPopulation("one", itemList, 2)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/grain.fsh"
        }
    }
    Component {
        id: blackAndWhite
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double strength: Controller.propertyPopulation("one", itemList, 0)
            readonly property double threshold: Controller.propertyPopulation("one", itemList, 1)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/blackAndWhite.fsh"
        }
    }
    Component {
        id: motionBlur
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property point imageShift: Controller.propertyPopulation("two", itemList, 0)
            readonly property int density: Controller.propertyPopulation("one", itemList, 1)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/motionBlur.fsh"
        }
    }
    Component {
        id: gaussianBlur
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double u_radius: Controller.propertyPopulation("one", itemList, 0)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gaussianBlur.fsh"
        }
    }
    Component {
        id: gaussianUnblur
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double u_radius: Controller.propertyPopulation("one", itemList, 0)
            readonly property double amount: Controller.propertyPopulation("one", itemList, 1)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gaussianUnblur.fsh"
        }
    }
    Component {
        id: toneMap
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double lowerRange: Controller.propertyPopulation("one", itemList, 0)
            readonly property double upperRange: Controller.propertyPopulation("one", itemList, 1)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/toneMap.fsh"
        }
    }
    Component {
        id: grid
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double rows: parseInt(Controller.propertyPopulation("one", itemList, 0))
            readonly property double columns: parseInt(Controller.propertyPopulation("one", itemList, 1))
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/grid.fsh"
        }
    }
    Component {
        id: gridSection
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double rows: parseInt(Controller.propertyPopulation("one", itemList, 0))
            readonly property double columns: parseInt(Controller.propertyPopulation("one", itemList, 1))
            readonly property point cellPosition: Controller.propertyPopulation("two", itemList, 2)
            readonly property bool fixedPosition: Controller.propertyPopulation("one", itemList, 3)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gridSection.fsh"
        }
    }
    Component {
        id: colorCurve
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double red: Controller.propertyPopulation("one", itemList, 0)
            readonly property double green: Controller.propertyPopulation("one", itemList, 1)
            readonly property double blue: Controller.propertyPopulation("one", itemList, 2)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorCurve.fsh"
        }
    }
    Component {
        id: overlayEffect
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property bool inversion2: Controller.propertyPopulation("one", itemList, 0)
            readonly property int overlayMode: parseInt(Controller.propertyPopulationDropdown(layersModel, layerIndex, 2))
            readonly property bool sharpMask2: Controller.propertyPopulation("one", itemList, 3)
            readonly property real opacity_level: Controller.propertyPopulationDropdown(layersModel, layerIndex, 4)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            readonly property variant src2: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 0, "index")[0], baseImage, 0)
            readonly property variant src3: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 1, "index")[0], baseImage, 1)
            fragmentShader: "qrc:/Effects/overlay.fsh"
        }
    }
    Component {
        id: mirrorEffect
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property int horizontalFlip: Controller.propertyPopulation("one", itemList, 0)
            readonly property int verticalFlip: Controller.propertyPopulation("one", itemList, 1)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/mirror.fsh"
        }
    }
    Component {
        id: colorHighlight
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property point coordinates: Controller.propertyPopulation("two", itemList, 0)
            readonly property double tolerance: Controller.propertyPopulation("one", itemList, 1)
            //readonly property double radius: Controller.propertyPopulation("one", itemList, 2)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorHighlight.fsh"
        }
    }
    Component {
        id: blur
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double u_radius: Controller.propertyPopulation("one", itemList, 0)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/blur.fsh"
        }
    }
    Component {
        id: unblur
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double u_radius: Controller.propertyPopulation("one", itemList, 0)
            readonly property double amount: Controller.propertyPopulation("one", itemList, 1)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/unblur.fsh"
        }
    }
    Component {
        id: rotationEffect
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double angle: Controller.propertyPopulation("one", itemList, 0)
            readonly property point center: Controller.propertyPopulation("two", itemList, 1)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/rotation.fsh"
        }
    }
    Component {
        id: negativeEffect
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property double strength: Controller.propertyPopulation("one", itemList, 0)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/negative.fsh"
        }
    }
    Component {
        id: combinationMask
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property var src2: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 0, "index")[0], baseImage, 0)
            readonly property var src3: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 1, "index")[0], baseImage, 1)
            readonly property bool inversion2: Controller.propertyPopulation("one", itemList, 0)
            readonly property bool inversion3: Controller.propertyPopulation("one", itemList, 1)
            readonly property double opacity_str: Controller.propertyPopulation("one", itemList, 2)
            readonly property int overlayMode: parseInt(Controller.propertyPopulationDropdown(layersModel, layerIndex, 3))
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/combinationMask.fsh"
        }
    }
    Component {
        id: colorFill
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property bool auto_determ: Controller.propertyPopulation("one", itemList, 0)
            readonly property real red: Controller.propertyPopulation("one", itemList, 1)
            readonly property real green: Controller.propertyPopulation("one", itemList, 2)
            readonly property real blue: Controller.propertyPopulation("one", itemList, 3)
            readonly property real alpha: Controller.propertyPopulation("one", itemList, 4)
            readonly property point coordinates: Controller.propertyPopulation("two", itemList, 5)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorFill.fsh"
        }
    }
    Component {
        id: gammaCorrection
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property bool encode: Controller.propertyPopulation("one", itemList, 0)
            readonly property real gamma: Controller.propertyPopulation("one", itemList, 1)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gammaCorrection.fsh"
        }
    }
    Component {
        id: contrastCorrection
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real strength: Controller.propertyPopulation("one", itemList, 0)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/contrastCorrection.fsh"
        }
    }
    Component {
        id: brightnessCorrection
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real strength: Controller.propertyPopulation("one", itemList, 0)
            readonly property point pos: Controller.propertyPopulation("two", itemList, 1)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/brightnessCorrection.fsh"
        }
    }
    Component {
        id: colorSwap
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real color_r: Controller.propertyPopulation("one", itemList, 2)
            readonly property real color_g: Controller.propertyPopulation("one", itemList, 3)
            readonly property real color_b: Controller.propertyPopulation("one", itemList, 4)
            readonly property real color_a: Controller.propertyPopulation("one", itemList, 5)
            readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorSwap.fsh"
        }
    }
    Component {
        id: pixelation
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real strength: Controller.propertyPopulation("one", itemList, 0)
            // readonly property bool isOverlay: overLay
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/pixelation.fsh"
        }
    }
    Component {
        id: depixelation
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real strength: Controller.propertyPopulation("one", itemList, 0)
            readonly property real amount: Controller.propertyPopulation("one", itemList, 1)
            readonly property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/depixelation.fsh"
        }
    }
    function setCanvaFunctions() {
        canvaFunctions.reActivateLayer = reActivateLayer
    }
    function reActivateLayer(idx, iteration) {
        Controller.reActivateLayer(layersModel, overlayEffectsModel, idx, iteration, finalImage)
    }
}
