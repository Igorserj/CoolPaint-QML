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
                    if (name === "History") {
                        history()
                    } else if (name === "Undo") {
                        undo()
                    } else if (name === "Redo") {
                        redo()
                    }
                }
            }
        }
    }
    ActionsBarModel {
        id: actionsBarModel
    }
    function includes({str = '', subStrs = ['']}) {
        let result = false
        for (const subStr of subStrs) {
            if (RegExp(subStr).test(str)) {
                result = true
                break
            }
        }
        return result
    }

    function undo() {
        if (stepIndex !== -1) {
            console.log(actionsLog.get(stepIndex).name)
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
                                    subStrs: ['value of', 'Set state of']
                                })) {
                leftPanelFunctions.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.prevValue.val, item.name)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStr: ['Set blending mode']
                                })) {
                leftPanelFunctions.setBlendingMode(item.index, item.subIndex, item.valIndex, item.prevValue.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                leftPanelFunctions.setLayersOrder(item.prevValue.val, item.value.val)
            }

            stepIndex -= 1
        }
    }
    function redo() {
        if (stepIndex !== actionsLog.count - 1) {
            stepIndex += 1

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
                                    subStrs: ['value of', 'Set state of']
                                })) {
                leftPanelFunctions.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.value.val, item.name)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStr: ['Set blending mode']
                                })) {
                leftPanelFunctions.setBlendingMode(item.index, item.subIndex, item.valIndex, item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                leftPanelFunctions.setLayersOrder(item.value.val, item.prevValue.val)
            }
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
