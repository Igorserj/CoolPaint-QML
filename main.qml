import QtQuick 2.15
import QtQuick.Window 2.15
import "Models"

Window {
    id: window
    property var doNotLog: ['view', 'export']
    property int stepIndex: -1
    width: 1280
    height: 720
    visible: true
    title: qsTr("Cool Paint")

    UI {
        id: ui
    }
    EffectsModel {
        id: effectsModel
    }
    LayersModel {
        id: layersModel
    }
    OverlayEffectsModel {
        id: overlayEffectsModel
    }
    ViewsModel {
        id: viewsModel
    }
    ExportMenuModel {
        id: exportMenuModel
    }
    ActionsLog {
        id: actionsLog
    }
    MouseArea {
        acceptedButtons: "NoButton"
        focus: true
        Keys.onPressed: {
            console.log("pressed")
            if (event.key === Qt.Key_Z && (event.modifiers & (Qt.ControlModifier && Qt.ShiftModifier))) {
                ui.actionBar.redo()
            } else if (event.key === Qt.Key_Z && (event.modifiers & Qt.ControlModifier)) {
                ui.actionBar.undo()
            }
        }
    }
    function logAssign(historyMenuBlockModel, historyBlockModelGeneration) {
        actionsLog.historyMenuBlockModel = historyMenuBlockModel
        actionsLog.historyBlockModelGeneration = historyBlockModelGeneration
    }
}
