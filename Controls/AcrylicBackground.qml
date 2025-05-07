import QtQuick 2.15

Item {
    id: acrylicItem
    property Item background
    anchors.fill: parent
    states: [
        State {
            name: "active"
            PropertyChanges {
                target: ldr
                sourceComponent: blur
            }
        },
        State {
            name: "inactive"
            PropertyChanges {
                target: ldr
                sourceComponent: undefined
            }
        },
        State {
            name: "disabled"
            when: !uiEffects
            PropertyChanges {
                target: ldr
                sourceComponent: undefined
            }
        }
    ]
    Image {
        id: img
        source: ""
        anchors.fill: parent
        visible: false
    }
    Loader {
        id: ldr
        anchors.fill: parent
    }
    Component {
        id: blur
        ShaderEffect {
            property point u_resolution: Qt.point(window.width, window.height)
            property double u_radius: 4.
            property bool isOverlay: false
            property Image src: img
            fragmentShader: "qrc:/Effects/gaussianBlur.fsh"
        }
    }
    function activate() {
        if (!!background && state !== "disabled") {
            grabImg()
            state = "active"
        }
    }
    function deactivate() {
        if (state !== "disabled") state = "inactive"
    }
    function grabImg() {
        if (img.source !== "") background.grabToImage(result => img.source = result.url)
    }
}
