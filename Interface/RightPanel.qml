import QtQuick 2.15
import "../Controls"
import "../Models"
import "../Controllers/rightPanelController.js" as Controller

Rectangle {
    x: window.width - width
    width: biggerSide * 260
    height: window.height
    color: window.style.currentTheme.vinous
    Component.onCompleted: {
        viewsBlockPopulate()
        logAssign(historyMenuBlockModel, historyBlockModelGeneration)
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
        Controller.flushPropertiesBlockModel(propertiesModel, propertiesBlockModel)
        leftPanelFunctions.setLayerIndex(-1)
    }
    function getPropertiesBlockModel() {
        return propertiesBlockModel
    }
    function viewsBlockPopulate() {
        Controller.viewsBlockModelGeneration(viewsModel, viewsBlockModel)
    }
    function getViewsBlockModel() {
        return viewsBlockModel
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
            Controller.metadataBlockModelGeneration(metadataMenuBlockModel, projectData.imagePath, projectData.projectPath)
        }
    }
    function historyBlockModelGeneration(pageNo) {
        if (rightPanelFunctions.getState() === "history") {
            Controller.historyBlockModelGeneration(actionsLog, historyMenuBlockModel, pageNo)
        }
    }
    function addReplacerToHistory() {
        if (rightPanelFunctions.getState() === "history") {
            Controller.addReplacerToHistory(actionsLog, historyMenuBlockModel)
        }
    }
    function metadataFilterChoose(index) {
        Controller.metadataFilterChoose(metadataMenuBlockModel, index, projectData.imagePath, projectData.projectPath)
    }
    function open() {
        Controller.historyBlockModelGeneration(actionsLog, historyMenuBlockModel)
        spacer.spacerReset()
        spacer.y = (parent.height - spacer.height) / 2
        spacer.upperBlock = undefined
        spacer.lowerBlock = undefined
        state = "history"
        metadataBlockModelGeneration()
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
            getViewsBlockModel,
            metadataBlockModelGeneration,
            addReplacerToHistory
        }
    }
}
