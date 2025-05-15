import QtQuick 2.15

Item {
    id: controls
    property alias joystick: overlayControls.joystick
    property alias slider: overlayControls.slider
    property alias buttonWhite: overlayControls.buttonWhite
    property alias buttonDark: overlayControls.buttonDark
    property alias buttonLayers: overlayControls.buttonLayers
    property alias buttonSwitch: overlayControls.buttonSwitch
    property alias header: overlayControls.header
    property alias empty: overlayControls.empty
    property alias insertButton: insertButton
    property alias insertDropdown: insertDropdown
    width: controlsLoader.width
    height: controlsLoader.height
    Loader {
        id: controlsLoader
        width: item.width
        height: item.height
        visible: typeof(view) !== "undefined" ? (typeof(overlay) === "undefined" || !overlay) ? view.includes("normal") : view.includes("overlay") : true
        sourceComponent: typeof(controls[type]) !== "undefined" ? controls[type] : empty
    }
    OverlayControls {
        id: overlayControls
    }
    Component {
        id: insertButton
        InsertButton {}
    }
    Component {
        id: insertDropdown
        InsertDropdown {
            function clickAction() {controlsAction({name, type, index, val1, val2})}
        }
    }
    function controlsAction(item) {}
}
