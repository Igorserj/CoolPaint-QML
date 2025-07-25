import QtQuick 2.15
import "../Controls"
import "../Controllers/propertiesMenuController.js" as Controller

Item {
    property alias propertiesBlock: propertiesBlock
    Block {
        id: propertiesBlock
        y: window.height * 0.01
        blockModel: propertiesBlockModel
        function blockAction() { propertiesBlockActions(type, name, val, index) }
    }
    Block {
        id: viewsBlock
        y: parent.height / 2 + window.height * 0.01
        blockModel: viewsBlockModel
        function blockAction() { viewsBlockActions(name, val) }
    }
    Component.onCompleted: {
        spacer.upperBlock = propertiesBlock
        spacer.lowerBlock = viewsBlock
    }

    function propertiesBlockActions(type, name, val, index) {
        Controller.propertiesBlockActions(type, name, val, index, showPreview, leftPanelFunctions, rightPanelFunctions, canvaFunctions, setIterationIndex)
    }
    function viewsBlockActions(name, val) {
        Controller.viewsBlockActions(name, val, canvaFunctions, switchPreview)
    }
}
