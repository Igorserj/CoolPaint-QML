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
    property alias slot: slot
    property alias empty: empty
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
            text: name
            function clickAction() {controlsAction({name, type, index, val1, val2})}
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
        id: slot
        Slot {}
    }
    Component {
        id: empty
        QtObject {}
    }
}
