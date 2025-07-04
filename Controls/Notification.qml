import QtQuick 2.15

Rectangle {
    id: notification
    property string name: ""
    property int idleTime: 0
    property bool isHidden: true
    color: window.style.currentTheme.darkGlass
    width: window.width / 1280 * 240
    height: window.width / 1280 * 80
    enabled: false
    radius: strictStyle ? 0 : height / 4
    state: "hidden"
    onIsHiddenChanged: {
        if (!label.containsMouse && isHidden) {
            close()
        }
    }
    Behavior on y {
        PropertyAnimation {
            target: notification
            property: "y"
            duration: strictStyle ? 0 : 400
            easing.type: "OutBack"
        }
    }
    AcrylicBackground {
        id: acrylicBackground
        background: ui
        z: -1
    }
    MouseArea {
        anchors.fill: parent
    }
    TextBlock {
        id: label
        width: parent.width * 0.9
        x: parent.width * 0.05
        y: (parent.height - height) / 2
        text: parent.name
        onContainsMouseChanged: {
            if (!containsMouse && isHidden) {
                close()
            }
        }
    }
    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: notification
                x: (window.width - notification.width) / 2
                y: -notification.height
                enabled: false
            }
        },
        State {
            name: "visible"
            PropertyChanges {
                target: notification
                x: (window.width - notification.width) / 2
                y: window.height * 0.1
                enabled: true
            }
        }
    ]
    SequentialAnimation {
        id: idleAnimation
        running: false
        PauseAnimation {
            duration: idleTime
        }
        ScriptAction {
            script: {
                if (typeof(leftPanelFunctions.getEffectsBlockState) !== "undefined") {
                    console.log(leftPanelFunctions.getEffectsBlockState())
                    if (leftPanelFunctions.getEffectsBlockState() === "insertion" || leftPanelFunctions.getEffectsBlockState() === "insertion2") {
                        const notificationText = "Insertion mode\nChoose effect or layer"
                        name = notificationText
                        state = "visible"
                        isHidden = false
                    } else if (leftPanelFunctions.getEffectsBlockState() === "layerSwap") {
                        const notificationText = "Swap mode\nChoose layer to swap with"
                        name = notificationText
                        state = "visible"
                        isHidden = false
                    } else if (leftPanelFunctions.getEffectsBlockState() === "replacement") {
                        const notificationText = "Replacement mode\nChoose effect"
                        name = notificationText
                        state = "visible"
                        isHidden = false
                    } else {
                        isHidden = true
                    }
                } else isHidden = true
            }
        }
    }

    function open(text, time = 0) {
        if (state !== "visible") acrylicBackground.activate()
        idleAnimation.stop()
        name = text
        state = "visible"
        isHidden = false
        if (time > 0) {
            idleTime = time
            idleAnimation.running = true
        }
    }
    function close() {
        state = "hidden"
        acrylicBackground.deactivate()
    }
}
