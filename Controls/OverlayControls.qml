import QtQuick 2.15

Item {
    property alias joystick: joystick
    property alias slider: slider
    property alias buttonWhite: buttonWhite
    property alias buttonDark: buttonDark
    property alias buttonLayers: buttonLayers
    property alias buttonSwitch: buttonSwitch
    property alias header: header
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
            function clickAction() {controlsAction()}
        }
    }
    Component {
        id: buttonDark
        ButtonDark {
            w: wdth
            text: name
            function clickAction() {controlsAction()}
        }
    }
    Component {
        id: buttonLayers
        ButtonLayers {
            w: wdth
            text: name
            function clickAction() {controlsAction()}
        }
    }
    Component {
        id: buttonSwitch
        SwitchBlock {
            text: name
            function clickAction() {controlsAction()}
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
        id: empty
        QtObject {}
    }
}
