import QtQuick 2.15

Item {
    id: controls
    property alias joystick: overlayControls.joystick
    property alias slider: overlayControls.slider
    property alias buttonWhite: overlayControls.buttonWhite
    property alias buttonDark: overlayControls.buttonDark
    property alias buttonLayers: overlayControls.buttonLayers
    property alias buttonSwitch: overlayControls.buttonSwitch
    property alias buttonGoto: overlayControls.buttonGoto
    property alias header: overlayControls.header
    property alias empty: overlayControls.empty
    property alias insertButton: insertButton
    property alias insertDropdown: insertDropdown
    property alias textBlock: overlayControls.textBlock
    property alias slot: overlayControls.slot
    width: controlsLoader.width
    height: controlsLoader.height
    Loader {
        id: controlsLoader
        sourceComponent: (typeof(controls[type]) !== "undefined") ? controls[type] : empty
        onLoaded: {
            width = Qt.binding(() => item.width)
            height = Qt.binding(() => item.height)
        }
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
