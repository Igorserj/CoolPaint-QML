import QtQuick 2.15

Item {
    id: insertButton
    property int parentIndex: index
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: updating()
    ButtonDark {
        id: insertButtonRect
        function clickAction() {activateInsertion(index)}
    }
    Column {
        anchors.top: insertButtonRect.bottom
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

    function activateInsertion(index) {
        if (index === 0) {
            if (leftPanel.effectsBlockState !== "insertion") leftPanel.effectsBlockState = "insertion"
            else leftPanel.effectsBlockState = "enabled"
        }
        else if (index === 1) {
            if (leftPanel.effectsBlockState !== "insertion2") leftPanel.effectsBlockState = "insertion2"
            else leftPanel.effectsBlockState = "enabled"
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
