import QtQuick 2.15

Item {
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    Image {
        id: baseImage
        width: parent.width
        height: parent.height
        visible: false
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: finalImage
        width: baseImage.paintedWidth
        height: baseImage.paintedHeight
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

    function setImage(source) {
        baseImage.source = source
    }
    function layersModelUpdate(key, value, idx, index) {
        console.log('idx', idx)
        layersModel.get(idx).items.setProperty(index, key, value)
        let i = idx
        for (; i < layersModel.count; ++i) {
            console.log("i", i)
            layersModel.setProperty(i, "activated", false)
            effectComponents.layersRepeater.itemAt(i).children[0].grabReady = false
        }
        layersModel.setProperty(idx, "activated", true)
        // for (i = idx; i < layersModel.count; ++i) {
        //     layersModel.setProperty(i, "activated", true)
        // }
    }
}
