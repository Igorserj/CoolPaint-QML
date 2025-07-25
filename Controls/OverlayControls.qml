import QtQuick 2.15

Item {
    property alias joystick: joystick
    property alias slider: slider
    property alias buttonWhite: buttonWhite
    property alias buttonDark: buttonDark
    property alias buttonLayers: buttonLayers
    property alias buttonSwitch: buttonSwitch
    property alias buttonGoto: buttonGoto
    property alias buttonReplace: buttonReplace
    property alias header: header
    property alias textBlock: textBlock
    property alias textField: textField
    property alias insertDropdown: insertDropdown
    property alias slot: slot
    property alias empty: empty
    Component {
        id: joystick
        JoystickBlock {
            w: wdth
            text: name
        }
    }
    Component {
        id: slider
        SliderBlock {
            w: wdth
            text: name
            function clickAction() {
                let pi = -1
                if (typeof(parentIndex) !== "undefined") pi = parentIndex
                controlsAction({name, type, index, val1, "val2": pi})}
        }
    }
    Component {
        id: buttonWhite
        ButtonWhite {
            w: wdth
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: buttonDark
        ButtonDark {
            w: wdth
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: buttonLayers
        ButtonLayers {
            w: wdth
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: buttonSwitch
        SwitchBlock {
            w: wdth
            text: name
            function clickAction() {
                let pi = -1
                if (typeof(parentIndex) !== "undefined") pi = parentIndex
                controlsAction({name, type, index, val1, "val2": pi})
            }
        }
    }
    Component {
        id: header
        Header {
            w: wdth
            text: name
        }
    }
    Component {
        id: textBlock
        TextBlock {
            w: wdth
            text: name
        }
    }
    Component {
        id: buttonGoto
        ButtonGoto {
            w: wdth
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: buttonReplace
        ButtonReplace {
            w: wdth
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: textField
        TextField {
            w: wdth
            text: name
        }
    }
    Component {
        id: insertDropdown
        InsertDropdown {
            w: wdth
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    Component {
        id: slot
        Slot {}
    }
    Component {
        id: empty
        QtObject {}
    }
}
