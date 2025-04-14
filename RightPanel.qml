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
    Component.onCompleted: {
        viewsBlockPopulate()
        logAssign(historyMenuBlockModel, Controller.historyBlockModelGeneration)
    }
    state: "default"
    states: [
        State {
            name: "default"
            PropertyChanges {
                target: rightPanelLoader
                sourceComponent: propertiesAndViewsComponent
            }
        },
        State {
            name: "history"
            PropertyChanges {
                target: rightPanelLoader
                sourceComponent: historyMenuComponent
            }
        }
    ]
    Loader {
        id: rightPanelLoader
        anchors.fill: parent
    }

    Component {
        id: propertiesAndViewsComponent
        PropertiesMenu {}
    }
    Component {
        id: historyMenuComponent
        HistoryMenu {}
    }
    Spacer {
        id: spacer
        y: (parent.height - height) / 2
    }

    PropertiesModel {
        id: propertiesModel
    }
    PropertiesBlockModel {
        id: propertiesBlockModel
    }
    ViewsBlockModel {
        id: viewsBlockModel
    }
    HistoryMenuBlockModel {
        id: historyMenuBlockModel
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
    function switchState() {
        if (state === "history") {
            close()
        } else if (state === "default") {
            canva.disableManipulator()
            open()
        }
    }
    function open() {
        Controller.historyBlockModelGeneration(actionsLog, historyMenuBlockModel, stepIndex)
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "history"
    }
    function close() {
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "default"
    }
}
