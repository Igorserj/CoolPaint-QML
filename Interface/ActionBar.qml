import QtQuick 2.15
import "../Controls"
import "../Models"

Item {
    x: (window.width - childrenRect.width) / 2
    Component.onCompleted: setActionBarFunctions()
    Row {
        Repeater {
            model: actionsBarModel
            delegate: Controls {
                enabled: (name === "Undo" && stepIndex === -1) ? false : (name === "Redo" && stepIndex === actionsLog.count - 1) ? false : true
                function controlsAction() {
                    switch (name) {
                    case "History":
                        name = "Properties"
                        history()
                        break
                    case "Properties":
                        name = "History"
                        history()
                        break
                    case "Undo":
                        undo()
                        break
                    case "Redo":
                        redo()
                        break
                    }
                }
            }
        }
    }
    ActionsBarModel {
        id: actionsBarModel
    }
    function includes({str = '', subStrs = []}) {
        let result = true
        for (const subStr of subStrs) {
            result = true
            for (let j = 0; j < subStr.length; ++j) {
                if (subStr[j] !== str[j]) {
                    result = false
                    break
                }
            }
            if (result) {
                break
            }
        }
        return result
    }

    function undo() {
        if (stepIndex !== -1) {
            projectSaved = false
            const item = actionsLog.get(stepIndex)
            if (includes({
                             str: actionsLog.get(stepIndex).name,
                             subStrs: ['Added effect']
                         })) {
                leftPanelFunctions.removeLayer(item.index, false)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set overlay effect', 'Set overlay layer']
                                })) {
                leftPanelFunctions.removeOverlayLayer(item.index, item.subIndex, item.prevValue.overlayEffectsModel)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Removed effect']
                                })) {
                leftPanelFunctions.layerRecovery(item.index, item.prevValue)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set value of', 'Set state of', 'Reset value of', 'Renamed layer']
                                })) {
                leftPanelFunctions.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.prevValue.val, item.name)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                if (item.prevValue.val !== -1 && item.prevValue.val < layersModel.count && item.value.val !== -1 && item.value.val < layersModel.count) {
                    leftPanelFunctions.setLayersBlockState("layerSwap")
                    leftPanelFunctions.setLayersOrder(item.prevValue.val, item.value.val)
                } else {
                    const notificationText = "Can't undo: Incorrect layer index"
                    popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                    setStepIndex(getStepIndex() + 1)
                }
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set blending mode']
                                })) {
                leftPanelFunctions.setBlendingMode(item.index, item.subIndex, item.valIndex, item.prevValue.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Replaced effect']
                                })) {
                leftPanelFunctions.removeLayer(item.index, false)
                leftPanelFunctions.layerRecovery(item.index, item.prevValue)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Moved layer']
                                })) {
                if (item.value.val < item.prevValue.val) {
                    leftPanelFunctions.moveLayer(item.value.val,
                                                 item.prevValue.val+1,
                                                 false)
                } else {
                    leftPanelFunctions.moveLayer(item.value.val-1,
                                                 item.prevValue.val,
                                                 false)
                }
            }
            setStepIndex(getStepIndex() - 1)
            rightPanelFunctions.addReplacerToHistory()
        } else {
            const notificationText = "Reached limit"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function redo() {
        if (stepIndex !== actionsLog.count - 1) {
            projectSaved = false
            setStepIndex(getStepIndex() + 1)

            const item = actionsLog.get(stepIndex)
            if (includes({
                             str: actionsLog.get(stepIndex).name,
                             subStrs: ['Added effect']
                         })) {
                leftPanelFunctions.addLayer(item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set overlay effect']
                                })) {
                leftPanelFunctions.addOverlayEffect(item.index, item.value.val, item.subIndex)
            } else if (includes({
                                     str: actionsLog.get(stepIndex).name,
                                     subStrs: ['Set overlay layer']
                                 })) {
                leftPanelFunctions.removeOverlayLayer(item.index, item.subIndex, item.value.overlayEffectsModel)
             } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Removed effect']
                                })) {
                leftPanelFunctions.removeLayer(item.index, false)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set value of', 'Set state of', 'Reset value of', 'Renamed layer']
                                })) {
                leftPanelFunctions.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.value.val, item.name)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                if (item.prevValue.val !== -1 && item.prevValue.val < layersModel.count && item.value.val !== -1 && item.value.val < layersModel.count) {
                    leftPanelFunctions.setLayersBlockState("layerSwap")
                    leftPanelFunctions.setLayersOrder(item.value.val, item.prevValue.val)
                } else {
                    const notificationText = "Can't redo: Incorrect layer index"
                    popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                    setStepIndex(getStepIndex() - 1)
                }
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set blending mode']
                                })) {
                leftPanelFunctions.setBlendingMode(item.index, item.subIndex, item.valIndex, item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Replaced effect']
                                })) {
                leftPanelFunctions.replacingLayer(item.index, item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Moved layer']
                                })) {
                leftPanelFunctions.moveLayer(item.prevValue.val, item.value.val, false)
            }
            rightPanelFunctions.addReplacerToHistory()
        } else {
            const notificationText = "Reached limit"
            popUpFunctions.openNotification(notificationText, notificationText.length * 100)
        }
    }
    function history() {
        rightPanelFunctions.switchState()
    }
    function setActionBarFunctions() {
        actionBarFunctions = {
            undo,
            redo
        }
    }
}
