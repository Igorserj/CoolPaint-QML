import QtQuick 2.15
import QtQuick.Window 2.15
import "Models"

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Cool Paint")

    UI {}
    EffectsModel {
        id: effectsModel
    }
    LayersModel {
        id: layersModel
    }
}