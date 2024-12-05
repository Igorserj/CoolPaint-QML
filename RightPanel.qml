import QtQuick 2.15
import "Controls"
import "Models"
import "Controllers/rightPanelController.js" as Controller

Rectangle {
    property alias propertiesModel: propertiesModel
    x: window.width - width
    width: window.width / 1280 * 260
    height: window.height
    color: "#302430"
    Block {
        height: parent.height - window.height * 0.005
        blockModel: propertiesBlockModel
    }
    function propertiesBlockUpdate() {
        Controller.propertiesBlockModelGeneration(propertiesModel, propertiesBlockModel)
    }
    function resetPropertiesBlock() {
        Controller.flushPropertiesBlockModel(propertiesBlockModel)
    }

    PropertiesModel {
        id: propertiesModel
    }
    PropertiesBlockModel {
        id: propertiesBlockModel
    }
}
