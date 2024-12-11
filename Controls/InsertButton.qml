import QtQuick 2.15

Item {
    id: insertButton
    property int parentIndex: index
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: update()
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
                        case "joystick": joystick; break;
                        case "slider": slider; break;
                        }
                    }
                }
                Component {
                    id: joystick
                    JoystickBlock {
                        text: name
                    }
                }
                Component {
                    id: slider
                    SliderBlock {
                        text: name
                    }
                }
            }
        }
    }

    function activateInsertion(index) {
        if (index === 0) leftPanel.effectsBlockState = "insertion"
        else if (index === 1) leftPanel.effectsBlockState = "insertion2"
    }

    function update() {
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
