import QtQuick 2.15

Column {
    id: insertButton
    property int parentIndex: index
    spacing: window.height * 0.005
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: updating()
    ButtonDark {
        id: insertButtonRect

        SequentialAnimation {
            loops: Animation.Infinite
            running: leftPanel.getEffectsBlockState() === "insertion" ? index === 0 : leftPanel.getEffectsBlockState() === "insertion2" ? index === 1 : false
            PropertyAnimation {
                target: insertButtonRect
                property: "color"
                from: style.darkGlassAccent
                to: "#5C9e619e"
                duration: 1000
                easing.type: "InOutQuad"
            }
            PropertyAnimation {
                target: insertButtonRect
                property: "color"
                from: "#5C9e619e"
                to: style.darkGlassAccent
                duration: 1500
                easing.type: "OutQuad"
            }
        }
        function clickAction() {activateInsertion(index)}
    }
    Column {
        spacing: window.height * 0.005
        Repeater {
            id: innerBlock
            Item {
                width: controlsLoader.width
                height: controlsLoader.height
                Loader {
                    id: controlsLoader
                    width: item.width
                    height: item.height
                    sourceComponent: {
                        switch (type) {
                        case "joystick": overlayControls.joystick; break;
                        case "slider": overlayControls.slider; break;
                        case "buttonSwitch": overlayControls.buttonSwitch; break;
                        default: overlayControls.empty; break
                        }
                    }
                }
                OverlayControls {
                    id: overlayControls
                }
            }
        }
    }
    StyleSheet {id: style}

    function activateInsertion(index) {
        const effectsBlockState = leftPanel.getEffectsBlockState()
        const setEffectsBlockState = leftPanel.setEffectsBlockState
        if (index === 0) {
            if (effectsBlockState !== "insertion") setEffectsBlockState("insertion")
            else setEffectsBlockState("enabled")
        }
        else if (index === 1) {
            if (effectsBlockState !== "insertion2") setEffectsBlockState("insertion2")
            else setEffectsBlockState("enabled")
        }
    }

    function updating() {
        const model = overlayEffectsModel.getModel(leftPanel.layerIndex, index)
        if (model.length !== 0) {
            insertButtonRect.text = model[0].name
            innerBlock.model = model[0].items
        } else {
            insertButtonRect.text = ""
            innerBlock.model = []
        }
    }
}
