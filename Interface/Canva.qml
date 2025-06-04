import QtQuick 2.15
import "../Controls"
import "../Models"

Item {
    property alias effectComponents: effectComponents
    property var finalImage
    property bool mirroring: false
    property bool smoothing: false
    property bool preserveAspect: true
    property double scaling: 1.
    property var srcList: []
    x: (window.width - width) / 2
    width: window.width / 1280 * (1280 - 2 * 260)
    height: window.height
    state: "default"
    states: [
        State {
            name: "default"
        },
        State {
            name: "manipulator"
        }
    ]
    Component.onCompleted: {
        checkerboardLoad()
        setCanvaFunctions()
    }
    Loader {
        id: checkerboardLoader
        anchors.fill: baseImage
        scale: scaling
    }
    Image {
        id: baseImage
        readonly property double aspect: sourceSize.width / sourceSize.height
        property double w: parent.width
        property double h: parent.height
        width: preserveAspect ? aspect > 1 ? w : height * aspect : w
        height: preserveAspect ? aspect > 1 ? w / aspect : h : h
        scale: scaling
        mirror: mirroring
        smooth: smoothing
        visible: layersModel.count === 0
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
    MouseArea {
        id: canvaArea
        property point currentPos: Qt.point(0, 0)
        anchors.fill: parent
        cursorShape: (canvaHScroller.state === "enabled" || canvaVScroller.state === "enabled") ? containsMouse
                                                                                                  ? Qt.ClosedHandCursor
                                                                                                  : Qt.OpenHandCursor : Qt.ArrowCursor
        onMouseXChanged: {
            if (parent.state === 'default' && canvaHScroller.state === "enabled") {
                canvaHScroller.wheelScroll((mouseX - currentPos.x) / 2, (mouseY - currentPos.y) / 2)
            }
        }
        onMouseYChanged: {
            if (parent.state === 'default' && canvaVScroller.state === "enabled") {
                canvaVScroller.wheelScroll((mouseX - currentPos.x) / 2, (mouseY - currentPos.y) / 2)
            }
        }
        onWheel: {
            canvaVScroller.wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
            canvaHScroller.wheelScroll(wheel.angleDelta.x, wheel.angleDelta.y)
        }
        onContainsMouseChanged: {
            if (canvaArea.containsMouse) {
                canvaArea.currentPos = Qt.point(canvaArea.mouseX, canvaArea.mouseY)
            }
        }
        onDoubleClicked: {
            if (helperContainer.state === "enlarged") helperAreaAction(getPreview())
        }
    }
    Repeater {
        model: layersModel
        delegate: Loader {}
    }
    EffectComponents {
        id: effectComponents
    }
    Rectangle {
        id: helperContainer
        color: window.style.currentTheme.lightDark
        visible: false
        x: (parent.width - width) - canvaVScroller.width
        y: (parent.height - height) - canvaHScroller.height
        state: "shrinked"
        states: [
            State {
                name: "shrinked"
                PropertyChanges {
                    target: helperContainer
                    width: baseImage.width / 8
                    height: baseImage.height / 8
                    color: window.style.currentTheme.lightDark
                }
                PropertyChanges {
                    target: helperArea
                    visible: true
                    enabled: true
                }
            },
            State {
                name: "enlarged"
                PropertyChanges {
                    target: helperContainer
                    width: baseImage.width
                    height: baseImage.height
                    x: baseImage.x
                    y: baseImage.y
                    scale: scaling
                    color: "transparent"
                }
                PropertyChanges {
                    target: helperArea
                    visible: false
                    enabled: false
                }
            },
            State {
                name: "disabled"
                PropertyChanges {
                    target: helperContainer
                    width: 0
                    height: 0
                    scale: 1
                    color: "transparent"
                }
                PropertyChanges {
                    target: helperArea
                    visible: false
                    enabled: false
                }
            }
        ]
        onStateChanged: console.log('State', state)
        Image {
            id: helperImage
            anchors.fill: parent
        }
        MouseArea {
            id: helperArea
            anchors.fill: parent
            drag.target: helperContainer
            drag.maximumX: helperContainer.parent.width - helperContainer.width - canvaVScroller.width
            drag.minimumX: canvaVScroller.width
            drag.maximumY: helperContainer.parent.height - helperContainer.height - canvaHScroller.height
            drag.minimumY: canvaHScroller.height
            cursorShape: Qt.SizeAllCursor
            onDoubleClicked: {
                helperAreaAction(getPreview())
            }
        }
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
        id: canvaVScroller
        scaling: parent.scaling
        anchors.right: parent.right
        height: parent.height
        baseVal: (parent.height - baseImage.height) / 2
        contentItem: baseImage
        contentSize: baseImage.height * scaling
    }
    ScrollerH {
        id: canvaHScroller
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
    Component {
        id: checkerboard
        ShaderEffect {
            readonly property point u_resolution: Qt.point(parent.width, parent.height)
            readonly property real density: window.density
            fragmentShader: "qrc:/Effects/checkerboard.fsh"
            Component.onCompleted: console.log(density)
        }
    }

    function helperAreaAction() {
        switch (helperContainer.state) {
        case "enlarged": {
            helperContainer.state = "shrinked"
            if (finalImage !== null) finalImage.visible = true
            break
        }
        case "shrinked": {
            helperContainer.state = "enlarged"
            if (finalImage !== null) finalImage.visible = false
            break
        }
        default: {
            helperContainer.state = "shrinked"
            if (finalImage !== null) finalImage.visible = true
            const index = !layersModel.get(leftPanelFunctions.getLayerIndex()).isRenderable ? leftPanelFunctions.getLayerIndex() : -1
            setHelperImage(index)
            break
        }
        }
    }
    function disableHelper() {
        helperContainer.state = "disabled"
        finalImage.visible = true
    }
    function srcListAppend(source, index, iteration = -1) {
        let idx = -1
        for (let i = 0; i < srcList.length; ++i) {
            if (srcList[i].index === index && srcList[i].iteration === iteration) {
                idx = i
                break
            }
        }
        if (idx !== -1) {
            srcList[idx].source = source
        } else {
            srcList.push({ "index": index, "iteration": iteration, "source": source })
        }
    }
    function checkerboardLoad() {
        checkerboardLoader.sourceComponent = undefined
        if (density >= 0) {
            checkerboardLoader.sourceComponent = checkerboard
            checkerboardLoader.visible = true
        } else {
            checkerboardLoader.visible = false
        }
    }
    function setCanvaState(newState) {
        state = newState
    }
    function getCanvaState() {
        return state
    }
    function setImage(source) {
        baseImage.source = source
        imageAssigned = true
    }
    function resetImage() {
        baseImage.source = ""
        imageAssigned = false
    }
    function layersModelUpdate(key, value, idx, index, subIndex = -1) {
        if (layersModel.count > 0) {
            if (key !== '') {
                if (subIndex === -1) layersModel.get(idx).items.setProperty(index, key, value)
                else overlayEffectsModel.getModel(idx, subIndex)[0].items.setProperty(index, key, value)
            }
            deactivateEffects(idx)
            if (!["Overlay", "Combination mask"].includes(layersModel.get(idx).name)) {
                layersModel.setProperty(idx, "activated", true)
            } else {
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
        setCanvaState('manipulator')
    }
    function disableManipulator() {
        manipulatorModel.clear()
        setCanvaState('default')
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
        if (value === 0 || value === 1) mirroring = value === 1
        else {console.log(`Wrong value: ${value} for mirroring`)}
    }
    function setSmoothing(value) {
        if (value === 0 || value === 1) smoothing = value === 1
        else {console.log(`Wrong value: ${value} for smoothing`)}
    }
    function setPreserveAspect(value) {
        if (value === 0 || value === 1) preserveAspect = value === 1
        else {console.log(`Wrong value: ${value} for preserve aspect`)}
    }
    function getFinalImage() {
        return finalImage
    }
    function setHelperImage(index) {
        if (index > -1) {
            for (let i = 0; i < srcList.length; ++i) {
                if (srcList[i].index === index && srcList[i].iteration === 0) {
                    helperContainer.visible = true
                    helperImage.source = srcList[i].source
                    break
                }
            }
        } else {
            helperContainer.visible = false
            helperContainer.state = "shrinked"
            try {
                finalImage.visible = true
            } catch (error) {
                console.log(error)
            }
            helperImage.source = ""
        }
    }
    function setCanvaFunctions() {
        canvaFunctions = {
            disableManipulator,
            enableManipulator,
            deactivateEffects,
            layersModelUpdate,
            setImage,
            resetImage,
            reDraw,
            getBaseImageDims,
            setScaling,
            setMirroring,
            setSmoothing,
            setPreserveAspect,
            getFinalImage,
            setImageSize,
            setCanvaState,
            getCanvaState,
            checkerboardLoad,
            setHelperImage,
            helperAreaAction,
            disableHelper
        }
    }
}
