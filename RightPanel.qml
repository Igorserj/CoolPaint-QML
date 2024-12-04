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

    Rectangle {
        color: "transparent"
        height: parent.height
        width: parent.width
        clip: true
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: propertiesBlockModel
                Repeater {
                    model: block
                    delegate: Controls {}
                }
            }
        }
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
