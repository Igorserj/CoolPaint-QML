import QtQuick 2.15

Rectangle {
    id: underscore
    width: parent.width / 3
    x: (parent.width - width) / 2
    y: parent.height - height * 2
    height: parent.height / 8
    opacity: 0
    radius: strictStyle ? 0 : height / 2
    color: parent.state === "active" ? style.currentTheme.lightDark : style.currentTheme.pinkWhiteAccent
    ParallelAnimation {
        running: !isRenderable
        PropertyAnimation {
            target: underscore
            property: "opacity"
            to: 1
            duration: 250
        }
        SequentialAnimation {
            PropertyAnimation {
                target: underscore
                property: "x"
                to: (underscore.parent.width - underscore.width) / 3
                duration: 250
            }
            PropertyAnimation {
                target: underscore
                property: "x"
                to: (underscore.parent.width - underscore.width) / 2
                duration: 250
                easing.type: Easing.OutExpo
            }
        }
    }
    ParallelAnimation {
        running: isRenderable
        PropertyAnimation {
            target: underscore
            property: "opacity"
            to: 0
            duration: 250
        }
        SequentialAnimation {
            PropertyAnimation {
                target: underscore
                property: "x"
                to: (underscore.parent.width - underscore.width) / 1.5
                duration: 250
                easing.type: Easing.OutExpo
            }
            PropertyAnimation {
                target: underscore
                property: "x"
                to: (underscore.parent.width - underscore.width) / 2
                duration: 250
            }
        }
    }
}
