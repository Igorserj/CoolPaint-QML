import QtQuick 2.15

Item {
    id: controls
    width: controlsLoader.width
    height: controlsLoader.height
    function controlsAction() {}
    Loader {
        id: controlsLoader
        width: item.width
        height: item.height
        sourceComponent: {
            switch (type) {
            case "joystick": joystick; break;
            case "slider": slider; break;
            case "insert": insertButton; break;
            case "buttonWhite": buttonWhite; break;
            case "buttonDark": buttonDark; break;
            case "buttonLayers": buttonLayers; break;
            case "header": header; break;
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
    Component {
        id: insertButton
        InsertButton {}
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
        id: header
        Header {
            w: wdth
            text: name
        }
    }
}
