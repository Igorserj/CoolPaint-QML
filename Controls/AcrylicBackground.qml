import QtQuick 2.15

Item {
    id: acrylicItem
    property Item background
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
            readonly property point u_resolution: Qt.point(window.width, window.height)
            readonly property double u_radius: 4.
            readonly property real transparency: 0
            readonly property variant src: img
            width: acrylicItem.width
            height: acrylicItem.height
            fragmentShader: "qrc:/Effects/blur.fsh"

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
            color: style.currentTheme.pinkWhite
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
                    img.source = ""
                    img.source = result.url

                    if (state !== "disabled") {
                        state = "active"
                    }
            })
        }
    }
}
