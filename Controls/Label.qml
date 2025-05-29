import QtQuick 2.15

Item {
    id: label
    property string text: ""
    property alias labelText: labelText
    property alias labelArea: labelArea
    property bool containsMouse: labelArea.containsMouse
    property int elide: Text.ElideNone
    property bool centered: false
    property int w: 30
    height: window.width / 1280 * w
    width: parent.width * 0.9
    clip: true
    states: [
        State {
            name: "normal"
            when: !(labelArea.containsMouse && (labelText.contentWidth > label.width)) && !centered
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
            name: "centered"
            when: !(labelArea.containsMouse && (labelText.contentWidth > label.width)) && centered
            PropertyChanges {
                target: textAnimation
                running: false
            }
            PropertyChanges {
                target: labelText
                x: label.width > labelText.width ? (label.width - labelText.width) / 2 : 0
            }
        },
        State {
            name: "wide"
            when: labelArea.containsMouse && (labelText.contentWidth > label.width)
            PropertyChanges {
                target: labelText
                x: 0
            }
            PropertyChanges {
                target: textAnimation
                running: true
            }
        }
    ]
    Text {
        id: labelText
        x: 0
        y: (label.height - labelText.contentHeight) / 2
        text: parent.text
        font.family: "Helvetica"
        font.bold: true
        elide: label.elide
        width: label.elide === 0 ? label.width : contentWidth
        color: window.style.currentTheme.pinkWhiteAccent
        font.pixelSize: parent.height / 27 * 12
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        id: labelArea
        hoverEnabled: true
        propagateComposedEvents: true
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
}
