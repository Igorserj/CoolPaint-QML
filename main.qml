import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1
import Coolpaint 1.0
import "Models"
import "Interface"
import "Controls"

Window {
    id: window
    property var doNotLog: ['view', 'export', 'settings']
    property int stepIndex: -1
    property string tmpFile: ""
    property var saveProj
    property bool lightTheme: false
    width: 1280
    height: 720
    visible: true
    title: qsTr("Cool Paint")
    Component.onCompleted: settingsLoading()
    onClosing: {
        close.accepted = false
        exitDialog.open()
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
    SettingsMenuModel {
        id: settingsMenuModel
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
        console.log("Saving!")
        if (tmpFile === "") {
            tmpFile = `${baseDir}/tmp/${Date.now()}.json`
        }
        saveProj(tmpFile)
    }
    function settingsLoading() {
        const settingsFile = `${baseDir}/settings.json`
        const data = fileIO.read(settingsFile)
        let i = 0
        let jsonData = ''
        if (data !== "") {
            jsonData = JSON.parse(data)
            for (; i < jsonData.settings.length; ++i) {
                const obj = jsonData.settings[i]
                if (obj.name === 'Count of autosaves') {
                    fileIO.remove(`${baseDir}/tmp`, parseInt(obj.val1))
                } else if (obj.name === 'Lights') {
                    lightTheme = obj.val1 === 1
                }
            }
        } else {
            const model = { 'settings': [] }
            for (; i < settingsMenuModel.count - 2; ++i) {
                model.settings.push(settingsMenuModel.get(i))
            }
            jsonData = JSON.stringify(model, null, '\t')
            const result = fileIO.write(settingsFile, jsonData)
        }
    }
}
