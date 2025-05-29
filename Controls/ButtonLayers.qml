import QtQuick 2.15

ButtonDark {
    property string swapState: blockRect.state === "layerSwap" && layerIndex === index ? "layerSwap" : "enabled"
    label.width: crossButton.x - (swapButton.x + swapButton.width) - width / 12

    Underscore {}
    ButtonWhite {
        id: swapButton
        w: parent.w / 6
        x: (parent.width / 24)
        y: (parent.height - height) / 2
        property string icon: "mover"
        property string type: blockRect.state
        function clickAction() {
            if (blockRect.state !== "layerSwap") {
                layerIndex = index
                blockRect.state = "layerSwap"
            }
            else blockRect.state = "enabled"
        }
    }
    ButtonWhite {
        id: crossButton
        w: parent.w / 6
        x: (parent.width - width) - (parent.width / 24)
        y: (parent.height - height) / 2
        text: "⨯"
        function clickAction() {
            removeLayer(index)
        }
    }
}
