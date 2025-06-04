function activateInsertion(index, leftPanelFunctions, name, setIterationIndex, animation) {
    const effectsBlockState = leftPanelFunctions.getEffectsBlockState()
    const setEffectsBlockState = leftPanelFunctions.setEffectsBlockState
    switch (name) {
    case "Mask": {
        if (effectsBlockState !== "insertion") {
            setEffectsBlockState("insertion")
            setIterationIndex(index)
        }
        else {
            setEffectsBlockState("enabled")
            setIterationIndex(-1)
        }
        break
    }
    case "Effect": {
        if (effectsBlockState !== "insertion2") {
            setEffectsBlockState("insertion2")
            setIterationIndex(index)
        }
        else {
            setEffectsBlockState("enabled")
            setIterationIndex(-1)
        }
        break
    }
    }
}

function dropdownChoose(optionName, optionIndex, setName, setVal, getVals, doNotLog, items, autoSave, actionsLog, setStepIndex, updateModel) {
    const { val1, idx, name, index, layerIndex, category } = getVals()
    const logging = !doNotLog.includes(category)
    if (category !== "settings") {
        console.log("Props", optionName, name)
        if (["Red", "Green", "Blue", "Alpha"].includes(optionName)) setName(`${name.substring(0, name.indexOf(":") + 1)} ${optionName}`)
        else setName(`Blending mode: ${optionName}`)
        if (logging) logAction(optionIndex, actionsLog, optionName, setStepIndex, getVals)
        setVal(optionIndex)
        items.setProperty(index, 'name', name)
        updateModel('val1', optionIndex, idx, index, -1)
        if (logging) modelFunctions.autoSave()
    } else {
        setName('Lights')
        setVal(optionIndex)
    }
}

function logAction(val2, actionsLog, optionName, setStepIndex, getVals) {
    const { val1, name, index, layerIndex, stepIndex, category } = getVals()
    actionsLog.trimModel(stepIndex)
    actionsLog.append({
                          block: category,
                          name: `Set blending mode to ${optionName}`,
                          prevValue: {val: val1},
                          value: {val: val2},
                          index: layerIndex, // layer number
                          subIndex: index, // sublayer number
                          propIndex: index, // sublayer property number
                          valIndex: 0
                      })
    setStepIndex(stepIndex + 1)
}
