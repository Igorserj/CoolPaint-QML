import QtQuick 2.15

Rectangle {
    id: button
    property string text: ""
    property alias buttonText: buttonText
    property alias area: area
    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }
    Behavior on radius {
        PropertyAnimation {
            target: button
            property: "radius"
            duration: 200
        }
    }
    Text {
        id: buttonText
        text: parent.text
        font.family: "Helvetica"
        font.bold: true
        anchors.centerIn: parent
    }
    MouseArea {
        id: area
        anchors.fill: parent
        enabled: button.enabled
        hoverEnabled: button.enabled
        onClicked: clickHandler()
    }

    function clickHandler() {
        clickAction()
    }
    function clickAction() {}
}
