import QtQuick 2.15
import "Controllers/effectsController.js" as Controller

Item {
    width: baseImage.paintedWidth
    height: baseImage.paintedHeight
    property alias layersRepeater: layersRepeater
    Repeater {
        id: layersRepeater
        model: layersModel
        delegate: Item {
            width: parent.width
            height: parent.height
            Loader {
                property var itemList: items
                property int layerIndex: index
                property bool grabReady: false
                asynchronous: true
                width: parent.width
                height: parent.height
                visible: false
                active: activated //&& (index === 0 || layersRepeater.itemAt(index - 1).children[0].grabReady)
                sourceComponent: Controller.addEffect(name)
                onLoaded: Controller.setImage(this, img)
            }
            Image {
                id: img
                width: parent.width
                height: parent.height
                visible: index === layersModel.count - 1
                onSourceChanged: Controller.reActivateLoader(layersModel, index)
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
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
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
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/vignette.fsh"
        }
    }
    Component {
        id: saturation
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property point strength: Controller.propertyPopulation("two", itemList, 0)
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/saturation.fsh"
        }
    }
    Component {
        id: grain
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double density: Controller.propertyPopulation("one", itemList, 0)
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
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
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
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
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
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
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
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
            property point cellPosition: Controller.propertyPopulation("two", itemList, 2)
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/grid.fsh"
        }
    }
    Component {
        id: colorCurve
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            property double red: Controller.propertyPopulation("one", itemList, 0)
            property double green: Controller.propertyPopulation("one", itemList, 1)
            property double blue: Controller.propertyPopulation("one", itemList, 2)
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
            property var src: Controller.srcPopulation(layersRepeater, layerIndex, baseImage)
            fragmentShader: "qrc:/Effects/colorCurve.fsh"
        }
    }
    Component {
        id: overlayEffect
        ShaderEffect {
            property point u_resolution: Qt.point(parent.width, parent.height)
            // property variant src: srcPopulation(parent, 0)
            // property variant src2: srcPopulation(parent, 1)
            // property variant src3: srcPopulation(parent, 2)
            property bool isOverlay: false
            // property bool isOverlay: Controller.propertyPopulation("overlay", itemList, -1)
            fragmentShader: "qrc:/Effects/overlay.fsh"
        }
    }
}