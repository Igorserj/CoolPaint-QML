import QtQuick 2.15

Item {
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    Image {
        id: baseImage
        width: parent.width
        height: parent.height
        visible: layersModel.count === 0
        fillMode: Image.PreserveAspectFit
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
    }
    function layersModelUpdate(key, value, idx, index) {
        console.log('idx', idx)
        layersModel.get(idx).items.setProperty(index, key, value)
        deactivateEffects(idx)
        layersModel.setProperty(idx, "activated", true)
    }
    function deactivateEffects(idx) {
        for (let i = idx; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "activated", false)
        }
    }
}
