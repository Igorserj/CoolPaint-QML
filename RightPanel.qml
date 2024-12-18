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
    Component.onCompleted: viewsBlockPopulate()
    Block {
        blockModel: propertiesBlockModel
    }
    Block {
        y: parent.height / 2
        blockModel: viewsBlockModel
    }
    function propertiesBlockUpdate() {
        Controller.propertiesBlockModelGeneration(propertiesModel, propertiesBlockModel)
    }
    function resetPropertiesBlock() {
        Controller.flushPropertiesBlockModel(propertiesBlockModel)
    }
    function viewsBlockPopulate() {
        Controller.viewsBlockModelGeneration(viewsModel, viewsBlockModel)
    }

    PropertiesModel {
        id: propertiesModel
    }
    PropertiesBlockModel {
        id: propertiesBlockModel
    }
    ViewsModel {
        id: viewsModel
    }
    ViewsBlockModel {
        id: viewsBlockModel
    }
}
