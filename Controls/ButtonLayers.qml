import QtQuick 2.15

ButtonDark {
    readonly property string name: typeof(nickname) !== "undefined" ? nickname : ""
    label.width: crossButton.x - (swapButton.x + swapButton.width) - width / 12

    Underscore {}
    ButtonWhite {
        id: swapButton
        w: parent.w / 6
        x: (parent.width / 24)
        y: (parent.height - height) / 2
        readonly property string icon: "mover"
        readonly property string type: blockRect.state
        function clickAction() {
            setIterationIndex(-1)
            let i
            if (blockRect.state !== "layerSwap") {
                setLayerIndex(idx)
                blockRect.state = "layerSwap"
            }
            else {
                for (i = layersModel.count * 2 - 2; i > 0; --i) {
                    if (layersBlockModel.get(1).block.get(i).type === "buttonReplace") {
                        layersBlockModel.get(1).block.remove(i)
                    }
                }
                blockRect.state = "enabled"
            }
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
