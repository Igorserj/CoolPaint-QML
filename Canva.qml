import QtQuick 2.15
import "Controls"
import "Models"

Item {
    property alias effectComponents: effectComponents
    property bool imageAssigned: false
    property Image finalImage
    property bool mirroring: false
    property bool smoothing: false
    property double scaling: 1.
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    Image {
        id: baseImage
        readonly property double aspectW: sourceSize.width / sourceSize.height > 1 ? w : height * sourceSize.width / sourceSize.height
        readonly property double aspectH: sourceSize.width / sourceSize.height > 1 ? width / sourceSize.width / sourceSize.height : h
        property double w: parent.width
        property double h: parent.height
        width: exportMenuModel.get(2).val1 === 1 ? aspectW : w
        height: exportMenuModel.get(2).val1 === 1 ? aspectH : h
        scale: scaling
        mirror: mirroring
        smooth: smoothing
        visible: layersModel.count === 0
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
    Repeater {
        model: layersModel
        delegate: Loader {}
    }
    EffectComponents {
        id: effectComponents
    }
    Repeater {
        model: manipulatorModel
        Joystick {
            width: baseImage.paintedWidth * scaling
            height: baseImage.paintedHeight * scaling
            anchors.centerIn: baseImage
            opacity: 0
            enabled: activated
            function xStick() {
                return joy.xStick(stickArea.pressed, stickArea.mouseX/stickArea.width*joy.stickArea.width)
            }
            function yStick() {
                return joy.yStick(stickArea.pressed, stickArea.mouseY/stickArea.height*joy.stickArea.height)
            }
        }
    }
    ManipulatorModel {
        id: manipulatorModel
    }

    function setImage(source) {
        baseImage.source = source
        imageAssigned = true
    }
    function layersModelUpdate(key, value, idx, index) {
        console.log('idx', idx, index)
        if (layersModel.count > 0) {
            layersModel.get(idx).items.setProperty(index, key, value)
            deactivateEffects(idx)
            if (layersModel.get(idx).name !== "Overlay") layersModel.setProperty(idx, "activated", true)
            else {
                const overlay = overlayEffectsModel.getModel(idx, 0)
                if (overlay.length > 0) {
                    overlay[0].activated = true
                }
            }
        }
    }
    function deactivateEffects(idx) {
        let i = idx
        for (; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "activated", false)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            if (overlayEffectsModel.get(i).idx >= idx) {
                overlayEffectsModel.setProperty(i, "activated", false)
            }
        }
    }
    function enableManipulator(joystick, props) {
        manipulatorModel.set(0, props)
    }
    function disableManipulator() {
        manipulatorModel.clear()
    }
    function setImageSize(w, h) {
        if (w !== -1) baseImage.w = w
        if (h !== -1) baseImage.h = h
    }
    function getBaseImageDims() {
        return {
            width: baseImage.paintedWidth,
            height: baseImage.paintedHeight,
            sourceW: baseImage.sourceSize.width,
            sourceH: baseImage.sourceSize.height,
            aspectW: width,
            aspectH: height
        }
    }
    function reDraw() {
        layersModelUpdate('', -1, 0, 0)
    }
}
