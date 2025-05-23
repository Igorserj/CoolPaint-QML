import QtQuick 2.15

Rectangle {
    id: button
    property string text: ""
    property Component image
    property alias buttonText: buttonText.labelText
    property alias label: buttonText
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
    Loader {
        layer.samples: 8
        layer.enabled: true
        sourceComponent: typeof(image) !== "undefined" ? image : ""
        anchors.centerIn: parent
    }
    MouseArea {
        id: area
        anchors.fill: parent
        enabled: button.enabled
        hoverEnabled: button.enabled
        onClicked: clickHandler()
    }
    Label {
        id: buttonText
        text: parent.text
        centered: true
        anchors.centerIn: parent
    }

    function clickHandler() {
        clickAction()
    }
    function clickAction() {}
}
