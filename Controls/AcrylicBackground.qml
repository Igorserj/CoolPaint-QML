import QtQuick 2.15

Item {
    id: acrylicItem
    property Item background
    // anchors.fill: parent
    width: parent.width
    height: parent.height

    states: [
        State {
            name: "active"
            PropertyChanges {
                target: ldr
                sourceComponent: strictStyle ? shadow : blur
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
            when: !uiFx
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
    }

    Component {
        id: blur
        ShaderEffect {
            property point u_resolution: Qt.point(window.width, window.height)
            property double u_radius: 4.
            property bool isOverlay: false
            property variant src: img
            width: acrylicItem.width
            height: acrylicItem.height
            fragmentShader: "qrc:/Effects/blur.fsh"

            // Monitor window size changes and regrab image
            onU_resolutionChanged: {
                if (acrylicItem.state === "active") {
                    regrabTimer.restart()
                }
            }
        }
    }
    Component {
        id: shadow
        Rectangle {
            width: acrylicItem.width + 4
            height: acrylicItem.height + 4
            color: "black"
        }
    }

    Timer {
        id: regrabTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (state === "active" && !!background) {
                grabImg()
            }
        }
    }

    function activate() {
        if (!!background && state !== "disabled") {
            // First set to inactive to clear any existing shader
            state = "inactive"
            grabImg()
        }
    }

    function deactivate() {
        if (state !== "disabled") state = "inactive"
    }

    function grabImg() {
        if (!!background) {
            background.grabToImage(function(result) {
                    // Clear old source and set new one
                    img.source = ""
                    img.source = result.url

                    // Only activate after the image is successfully grabbed
                    if (state !== "disabled") {
                        state = "active"
                    }
            })
        }
    }
}
