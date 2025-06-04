import QtQuick 2.15

Rectangle {
    id: button
    property string text: ""
    property Component image
    property alias buttonText: buttonText.labelText
    property alias label: buttonText
    property alias area: area
    property alias shapes: shapes
    Component.onCompleted: if (typeof(icon) !== "undefined") {
                               image = shapes[icon]
                           }
    Behavior on color {
        ColorAnimation {
            duration: strictStyle ? 0 : 200
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
        smooth: true
        layer.samples: 4
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
        text: visible ? parent.text : ""
        centered: true
        anchors.centerIn: parent
        visible: !!!image
    }
    ShapesStorage {
        id: shapes
        Component.onCompleted: {
            if (typeof(icon) !== "undefined" && ["newProj", "open", "openProj", "saveAs", "exportImg", "home"].includes(icon)) shapeState = Qt.binding(() => area.containsMouse ? "hovered" : "default")
        }
    }

    function clickHandler() {
        clickAction()
    }
    function clickAction() {}
}
