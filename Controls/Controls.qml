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
        visible: typeof(view) !== "undefined" ? (typeof(overlay) === "undefined" || !overlay) ? view.includes("normal") : view.includes("overlay") : true
        sourceComponent: {
            switch (type) {
            case "joystick": overlayControls.joystick; break;
            case "slider": overlayControls.slider; break;
            case "insert": insertButton; break;
            case "buttonWhite": overlayControls.buttonWhite; break;
            case "buttonDark": overlayControls.buttonDark; break;
            case "buttonLayers": overlayControls.buttonLayers; break;
            case "buttonSwitch": overlayControls.buttonSwitch; break;
            case "header": overlayControls.header; break;
            default: overlayControls.empty; break;
            }
        }
    }
    OverlayControls {
        id: overlayControls
    }

    Component {
        id: insertButton
        InsertButton {}
    }
}
