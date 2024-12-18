import QtQuick 2.15

Item {
    property bool imageAssigned: false
    property Image finalImage//: baseImage
    property bool mirroring: false
    property double scaling: 1.
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    Image {
        id: baseImage
        width: parent.width
        height: parent.height
        scale: scaling
        visible: layersModel.count === 0
        fillMode: Image.PreserveAspectFit
        mirror: mirroring
    }
    Repeater {
        model: layersModel
        delegate: Loader {}
    }
    EffectComponents {
        id: effectComponents
    }

    function setImage(source) {
        baseImage.source = source
        imageAssigned = true
    }
    function layersModelUpdate(key, value, idx, index) {
        console.log('idx', idx, index)
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
}
