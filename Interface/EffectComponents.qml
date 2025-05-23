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
                onLoaded: Controller.setImage(this, img, img3, isRenderable, index)
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
                onSourceChanged: Controller.reActivateLoader(layersModel, overlayEffectsModel, index)
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
                onLoaded: Controller.setImage(this, img2, undefined, true, index)
            }
            Image {
                id: img2
                width: parent.width
                height: parent.height
                smooth: smoothing
                x: (baseImage.width - width) / 2
                y: (baseImage.height - height) / 2
                visible: false
                onSourceChanged: Controller.reActivateLayer(layersModel, overlayEffectsModel, idx, iteration, finalImage)
            }
        }
    }
    Component {
        id: colorShift
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property point imageRShift: Controller.propertyPopulation("two", itemList, 0)
            property point imageGShift: Controller.propertyPopulation("two", itemList, 1)
            property point imageBShift: Controller.propertyPopulation("two", itemList, 2)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorShift.fsh"
        }
    }
    Component {
        id: vignette
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double upperRange: Controller.propertyPopulation("one", itemList, 0)
            property double lowerRange: Controller.propertyPopulation("one", itemList, 1)
            property point center: Controller.propertyPopulation("two", itemList, 2)
            property double roundness: Controller.propertyPopulation("one", itemList, 3)
            property double aspect: parent.width / parent.height
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/vignette.fsh"
        }
    }
    Component {
        id: saturation
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property point strength: Controller.propertyPopulation("two", itemList, 0)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/saturation.fsh"
        }
    }
    Component {
        id: grain
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double density: Controller.propertyPopulation("one", itemList, 0)
            property double lowerRange: Controller.propertyPopulation("one", itemList, 1)
            property double upperRange: Controller.propertyPopulation("one", itemList, 2)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/grain.fsh"
        }
    }
    Component {
        id: blackAndWhite
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double strength: Controller.propertyPopulation("one", itemList, 0)
            property double threshold: Controller.propertyPopulation("one", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/blackAndWhite.fsh"
        }
    }
    Component {
        id: motionBlur
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property point imageShift: Controller.propertyPopulation("two", itemList, 0)
            property int density: Controller.propertyPopulation("one", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/motionBlur.fsh"
        }
    }
    Component {
        id: toneMap
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double lowerRange: Controller.propertyPopulation("one", itemList, 0)
            property double upperRange: Controller.propertyPopulation("one", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/toneMap.fsh"
        }
    }
    Component {
        id: grid
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double rows: parseInt(Controller.propertyPopulation("one", itemList, 0))
            property double columns: parseInt(Controller.propertyPopulation("one", itemList, 1))
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/grid.fsh"
        }
    }
    Component {
        id: gridSection
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double rows: parseInt(Controller.propertyPopulation("one", itemList, 0))
            property double columns: parseInt(Controller.propertyPopulation("one", itemList, 1))
            property point cellPosition: Controller.propertyPopulation("two", itemList, 2)
            property bool fixedPosition: Controller.propertyPopulation("one", itemList, 3)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gridSection.fsh"
        }
    }
    Component {
        id: colorCurve
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double red: Controller.propertyPopulation("one", itemList, 0)
            property double green: Controller.propertyPopulation("one", itemList, 1)
            property double blue: Controller.propertyPopulation("one", itemList, 2)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorCurve.fsh"
        }
    }
    Component {
        id: overlayEffect
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property variant src2: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 0, "index")[0], baseImage, 0)
            property variant src3: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 1, "index")[0], baseImage, 1)
            property int overlayMode: parseInt(Controller.propertyPopulationDropdown(layersModel, layerIndex, 2))
            property bool inversion2: Controller.propertyPopulation("one", itemList, 0)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/overlay.fsh"
        }
    }
    Component {
        id: mirrorEffect
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property int horizontalFlip: Controller.propertyPopulation("one", itemList, 0)
            property int verticalFlip: Controller.propertyPopulation("one", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/mirror.fsh"
        }
    }
    Component {
        id: colorHighlight
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property point coordinates: Controller.propertyPopulation("two", itemList, 0)
            property double tolerance: Controller.propertyPopulation("one", itemList, 1)
            // property double radius: Controller.propertyPopulation("one", itemList, 2)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorHighlight.fsh"
        }
    }
    Component {
        id: gaussianBlur
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double u_radius: Controller.propertyPopulation("one", itemList, 0)
            // property double u_sigma: Controller.propertyPopulation("one", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/gaussianBlur.fsh"
        }
    }
    Component {
        id: rotationEffect
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double angle: Controller.propertyPopulation("one", itemList, 0)
            property point center: Controller.propertyPopulation("two", itemList, 1)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/rotation.fsh"
        }
    }
    Component {
        id: negativeEffect
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double opacity_str: Controller.propertyPopulation("one", itemList, 0)
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/negative.fsh"
        }
    }
    Component {
        id: combinationMask
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property var src2: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 0, "index")[0], baseImage, 0)
            property var src3: Controller.srcPopulation(overlaysRepeater, overlayEffectsModel.getModel(layerIndex, 1, "index")[0], baseImage, 1)
            property bool inversion2: Controller.propertyPopulation("one", itemList, 0)
            property bool inversion3: Controller.propertyPopulation("one", itemList, 1)
            property double opacity_str: Controller.propertyPopulation("one", itemList, 2)
            property int overlayMode: parseInt(Controller.propertyPopulationDropdown(layersModel, layerIndex, 3))
            property bool isOverlay: overLay
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/combinationMask.fsh"
        }
    }
    function setCanvaFunctions() {
        canvaFunctions.reActivateLayer = reActivateLayer
    }
    function reActivateLayer(idx, iteration) {
        Controller.reActivateLayer(layersModel, overlayEffectsModel, idx, iteration, finalImage)
    }
}
