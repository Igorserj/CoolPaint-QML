import QtQuick 2.15

Item {
    id: insertButton
    property int parentIndex: index
    width: childrenRect.width
    height: childrenRect.height
    Component.onCompleted: update()
    ButtonDark {
        id: insertButtonRect
        function clickAction() {activateInsertion()}
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

    function activateInsertion() {
        if (els.state === "default") {
            insertIndex = [controls.controlsIndex, index, this]
            els.state = "overlay"
        }
        else if (els.state === "overlay") {
            insertIndex = [-1, -1, undefined]
            els.state = "default"
        }
    }

    function update() {
        const model = im.getModel(controls.controlsIndex, index)
        if (model[0] !== -1) {
            insertButtonRect.text = model[0].name
            innerBlock.model = model[0].items
        } else {
            insertButtonRect.text = ""
            innerBlock.model = []
        }
    }
}
