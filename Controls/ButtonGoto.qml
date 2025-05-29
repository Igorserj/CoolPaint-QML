import QtQuick 2.15

ButtonDark {
    Loader {
        layer.samples: 8
        layer.enabled: true
        sourceComponent: shapes.boxArrow
        x: parent.width * 0.96 - width
        y: (parent.height - height) / 2
    }
    // ShapesStorage {
    //     id: shapes
    //     // shapeState: "down"
    // }
}
