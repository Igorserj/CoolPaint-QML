import QtQuick 2.15

Rectangle {
    id: header
    property string text: ""
    property alias headerText: headerText
    property alias area: area
    property int w: 240
    height: biggerSide * w / 6
    width: biggerSide * w
    state: "enabled"
    states: [
        State {
            name: "enabled"
            PropertyChanges {
                target: header
                color: window.style.currentTheme.dark
                radius: strictStyle ? 0 : width / 4
            }
            PropertyChanges {
                target: headerText
                color: window.style.currentTheme.pinkWhiteAccent
                font.pixelSize: biggerSide * w / 6 / 40 * 16
            }
        }
    ]
    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }
    Behavior on radius {
        PropertyAnimation {
            target: header
            property: "radius"
            duration: 200
        }
    }
    Text {
        id: headerText
        text: parent.text
        font.family: "Helvetica"
        font.bold: true
        anchors.centerIn: parent
    }
    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: clickAction()
    }

    function clickAction() {}
}
