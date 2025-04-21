import QtQuick 2.15
import "../Controls"
import "../Models"

Item {
    x: (window.width - childrenRect.width) / 2
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
                leftPanel.removeLayer(item.index, false)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set overlay effect']
                                })) {
                leftPanel.removeOverlayLayer(item.index, item.subIndex, item.prevValue.overlayEffectsModel)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Removed effect']
                                })) {
                leftPanel.layerRecovery(item.index, item.prevValue)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['value of', 'Set state of']
                                })) {
                leftPanel.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.prevValue.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStr: ['Set blending mode']
                                })) {
                leftPanel.setBlendingMode(item.index, item.subIndex, item.valIndex, item.prevValue.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                leftPanel.setLayersOrder(item.prevValue.val, item.value.val)
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
                leftPanel.addLayer(item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Set overlay effect']
                                })) {
                leftPanel.addOverlayLayer(item.index, item.value.val, item.subIndex === 0 ? "insertion" : "insertion2")
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Removed effect']
                                })) {
                leftPanel.removeLayer(item.index, false)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['value of', 'Set state of']
                                })) {
                leftPanel.setValue(item.index, item.subIndex, item.propIndex, item.valIndex, item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStr: ['Set blending mode']
                                })) {
                leftPanel.setBlendingMode(item.index, item.subIndex, item.valIndex, item.value.val)
            } else if (includes({
                                    str: actionsLog.get(stepIndex).name,
                                    subStrs: ['Swap layers']
                                })) {
                leftPanel.setLayersOrder(item.value.val, item.prevValue.val)
            }
        }
    }
    function history() {
        rightPanel.switchState()
    }
}
