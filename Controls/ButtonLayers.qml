import QtQuick 2.15

ButtonDark {
    property string swapState: blockRect.state === "layerSwap" && layerIndex === index ? "layerSwap" : "enabled"

    ButtonWhite {
        w: parent.w / 6
        x: (parent.width - width) - (parent.width / 24)
        y: (parent.height - height) / 2
        text: "⨯"
        function clickAction() {
            removeLayer(index)
        }
    }
    ButtonWhite {
        w: parent.w / 6
        x: (parent.width / 24)
        y: (parent.height - height) / 2
        image: shapes.mover
        function clickAction() {
            if (blockRect.state !== "layerSwap") {
                layerIndex = index
                blockRect.state = "layerSwap"
            }
            else blockRect.state = "enabled"
        }
    }
    ShapesStorage {
        id: shapes
        shapeState: blockRect.state
    }
}
