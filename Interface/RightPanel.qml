import QtQuick 2.15
import "../Controls"
import "../Models"
import "../Controllers/rightPanelController.js" as Controller

Rectangle {
    x: window.width - width
    width: window.width / 1280 * 260
    height: window.height
    color: window.style.currentTheme.vinous
    Component.onCompleted: {
        viewsBlockPopulate()
        logAssign(historyMenuBlockModel, Controller.historyBlockModelGeneration)
        setRightPanelFunctions()
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
    WorkerScript {
        id: historyWorker
        source: "../Controllers/historyBlockModelGeneration.mjs"
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
    MetadataMenuBlockModel {
        id: metadataMenuBlockModel
    }

    function propertiesBlockUpdate() {
        Controller.propertiesBlockModelGeneration(propertiesModel, propertiesBlockModel)
    }
    function resetPropertiesBlock() {
        Controller.flushPropertiesBlockModel(propertiesBlockModel)
        leftPanelFunctions.setLayerIndex(-1)
    }
    function getPropertiesBlockModel() {
        return propertiesBlockModel
    }
    function viewsBlockPopulate() {
        Controller.viewsBlockModelGeneration(viewsModel, viewsBlockModel)
    }
    function switchState() {
        if (state === "history") {
            close()
        } else if (state === "default") {
            canvaFunctions.disableManipulator()
            open()
        }
    }
    function getState() {
        return state
    }
    function getPropertiesModel() {
        return propertiesModel
    }
    function metadataBlockModelGeneration() {
        if (rightPanelFunctions.getState() === "history") {
            Controller.metadataBlockModelGeneration(metadataMenuBlockModel, currentImagePath, currentProjectPath)
        }
    }
    function historyBlockModelGeneration(pageNo) {
        if (rightPanelFunctions.getState() === "history") {
            Controller.historyBlockModelGeneration(actionsLog, historyMenuBlockModel, pageNo)
        }
    }
    function open() {
        Controller.historyBlockModelGeneration(actionsLog, historyMenuBlockModel)
        metadataBlockModelGeneration()
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "history"
    }
    function close() {
        propertiesBlockUpdate()
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "default"
    }
    function setRightPanelFunctions() {
        rightPanelFunctions = {
            resetPropertiesBlock,
            switchState,
            propertiesBlockUpdate,
            getPropertiesModel,
            getPropertiesBlockModel,
            getState,
            metadataBlockModelGeneration
        }
    }
}
