import QtQuick 2.15
import "../Controls"
import "../Models"

Item {
    property alias effectComponents: effectComponents
    property Image finalImage
    property bool mirroring: false
    property bool smoothing: false
    property bool preserveAspect: true
    property double scaling: 1.
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    Component.onCompleted: setCanvaFunctions()
    Image {
        id: baseImage
        readonly property double aspect: sourceSize.width / sourceSize.height
        property double w: parent.width
        property double h: parent.height
        width: preserveAspect ? aspect > 1 ? w : height * aspect : w
        height: preserveAspect ? aspect > 1 ? width / aspect : h : h
        scale: scaling
        mirror: mirroring
        smooth: smoothing
        visible: layersModel.count === 0
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
    MouseArea {
        anchors.fill: parent
        onWheel: {
            canvaScroller.wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
        }
    }
    Repeater {
        model: layersModel
        delegate: Loader {}
    }
    EffectComponents {
        id: effectComponents
    }
    Repeater {
        model: manipulatorModel
        Joystick {
            width: baseImage.paintedWidth * scaling
            height: baseImage.paintedHeight * scaling
            anchors.centerIn: baseImage
            opacity: 0
            enabled: activated
            Component.onCompleted: prevVal = [val1, val2]
            function xStick() {
                const vals = joy.xStick(stickArea.pressed, stickArea.mouseX/stickArea.width*joy.stickArea.width)
                val1 = vals.value
                return {coord: vals.coord}
            }
            function yStick() {
                const vals = joy.yStick(stickArea.pressed, stickArea.mouseY/stickArea.height*joy.stickArea.height)
                val2 = vals.value
                return {coord: vals.coord}
            }
            function logAction() {
                logJoystick(category, index, val1, val2, prevVal, parentIndex, propIndex, name)
                prevVal = [val1, val2]
            }
        }
    }
    ScrollerV {
        id: canvaScroller
        scaling: parent.scaling
        anchors.right: parent.right
        height: parent.height
        baseVal: (parent.height - baseImage.height) / 2
        contentItem: baseImage
        contentSize: baseImage.height * scaling
    }
    ScrollerH {
        scaling: parent.scaling
        anchors.bottom: parent.bottom
        width: parent.width
        baseVal: (parent.width - baseImage.width) / 2
        contentItem: baseImage
        contentSize: baseImage.width * scaling
    }
    ManipulatorModel {
        id: manipulatorModel
    }

    function setImage(source) {
        baseImage.source = source
        imageAssigned = true
    }
    function layersModelUpdate(key, value, idx, index, subIndex = -1) {
        if (layersModel.count > 0) {
            if (key !== '') {
                if (subIndex === -1) layersModel.get(idx).items.setProperty(index, key, value)
                else overlayEffectsModel.getModel(idx, subIndex)[0].items.setProperty(index, key, value)
            }
            deactivateEffects(idx)
            if (!["Overlay", "Combination mask"].includes(layersModel.get(idx).name)) layersModel.setProperty(idx, "activated", true)
            else {
                const overlay = overlayEffectsModel.getModel(idx, 0)
                if (overlay.length > 0) {
                    overlay[0].activated = true
                }
            }
        }
    }
    function deactivateEffects(idx) {
        let i = idx
        for (; i < layersModel.count; ++i) {
            layersModel.setProperty(i, "activated", false)
        }
        for (i = 0; i < overlayEffectsModel.count; ++i) {
            if (overlayEffectsModel.get(i).idx >= idx && overlayEffectsModel.get(i).iteration < 2) {
                overlayEffectsModel.setProperty(i, "activated", false)
            }
        }
    }
    function enableManipulator(joystick, props) {
        manipulatorModel.set(0, props)
    }
    function disableManipulator() {
        manipulatorModel.clear()
    }
    function setImageSize(w, h) {
        if (w !== -1) baseImage.w = w
        if (h !== -1) baseImage.h = h
    }
    function getBaseImageDims() {
        return {
            width: baseImage.paintedWidth,
            height: baseImage.paintedHeight,
            sourceW: baseImage.sourceSize.width,
            sourceH: baseImage.sourceSize.height,
            aspectW: width,
            aspectH: height
        }
    }
    function reDraw() {
        layersModelUpdate('', -1, 0, 0)
    }
    function logJoystick(category, index, val1, val2, prevVal, subIndex, propIndex, name) {
        actionsLog.trimModel(stepIndex)
        actionsLog.append({
                              block: category,
                              name: `Set value of ${name} X to ${val1.toFixed(2)}`,
                              prevValue: {val: prevVal[0]},
                              value: {val: val1},
                              index: index, // layer number
                              subIndex: subIndex, // sublayer number
                              propIndex: propIndex, // sublayer property number
                              valIndex: 0
                          })
        stepIndex += 1
        actionsLog.append({
                              block: category,
                              name: `Set value of ${name} Y to ${val2.toFixed(2)}`,
                              prevValue: {val: prevVal[1]},
                              value: {val: val2},
                              index: index, // layer number
                              subIndex: subIndex, // sublayer number
                              propIndex: propIndex, // sublayer property number
                              valIndex: 1
                          })
        stepIndex += 1
        console.log(Object.entries(actionsLog.get(actionsLog.count-2)), Object.entries(actionsLog.get(actionsLog.count-1)))
    }
    function setScaling(value) {
        if (!isNaN(parseFloat(scaling))) scaling = value
        else console.log(`Wrong value. Value is not a number`)
    }
    function setMirroring(value) {
        if (value === 0 || value === 1) mirroring = Boolean(value)
        else {console.log(`Wrong value: ${value} for mirroring`)}
    }
    function setSmoothing(value) {
        if (value === 0 || value === 1) smoothing = Boolean(value)
        else {console.log(`Wrong value: ${value} for smoothing`)}
    }
    function setPreserveAspect(value) {
        if (value === 0 || value === 1) preserveAspect = Boolean(value)
        else {console.log(`Wrong value: ${value} for preserve aspect`)}
    }
    function getFinalImage() {
        return finalImage
    }
    function setCanvaFunctions() {
        canvaFunctions = {
            disableManipulator,
            deactivateEffects,
            layersModelUpdate,
            setImage,
            reDraw,
            getBaseImageDims,
            enableManipulator,
            setScaling,
            setMirroring,
            setSmoothing,
            setPreserveAspect,
            getFinalImage,
            setImageSize
        }
    }
}
