import QtQuick 2.15

Item {
    id: label
    property string text: ""
    property alias labelArea: labelArea
    height: window.width / 1280 * 30
    width: parent.width * 0.9
    clip: true
    states: [
        State {
            name: "normal"
            when: !(labelArea.containsMouse && (labelText.contentWidth > label.width))
            PropertyChanges {
                target: textAnimation
                running: false
            }
            PropertyChanges {
                target: labelText
                x: 0
            }
        },
        State {
            name: "wide"
            when: labelArea.containsMouse && (labelText.contentWidth > label.width)
            PropertyChanges {
                target: textAnimation
                running: true
            }
        }
    ]
    Text {
        id: labelText
        height: parent.height
        text: parent.text
        font.family: "Helvetica"
        font.bold: true
        color: style.pinkWhiteAccent
        font.pixelSize: parent.height / 27 * 12
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        id: labelArea
        hoverEnabled: true
        anchors.fill: labelText
    }
    SequentialAnimation {
        id: textAnimation
        alwaysRunToEnd: false
        loops: Animation.Infinite
        PauseAnimation {
            duration: 500
        }
        PropertyAnimation {
            target: labelText
            property: "x"
            from: 0
            to: label.width - labelText.contentWidth
            duration: Math.abs(to) * 30
        }
        PauseAnimation {
            duration: 1500
        }
        PropertyAnimation {
            target: labelText
            property: "x"
            from: label.width - labelText.contentWidth
            to: 0
            duration: Math.abs(label.width - labelText.contentWidth) * 5
        }
    }
    StyleSheet {id: style}
}
