import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1
import Coolpaint 1.0
import "Models"
import "Interface"
import "Controls"

Window {
    id: window
    property var doNotLog: ['view', 'export']
    property int stepIndex: -1
    property string tmpFile: ""
    property var saveProj
    width: 1280
    height: 720
    visible: true
    title: qsTr("Cool Paint")
    onClosing: {
        close.accepted = false
        exitDialog.open()
        // console.log("Close")
        // exitDialogLoader.sourceComponent = exitDialog
    }
    FileIO {
        id: fileIO
    }
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
    ExitDialog {
        id: exitDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
    function logAssign(historyMenuBlockModel, historyBlockModelGeneration) {
        actionsLog.historyMenuBlockModel = historyMenuBlockModel
        actionsLog.historyBlockModelGeneration = historyBlockModelGeneration
    }
    function autoSave() {
        if (tmpFile === "") {
            tmpFile = `${baseDir}/tmp/${Date.now()}.json`
        }
        saveProj(tmpFile)
    }
}
