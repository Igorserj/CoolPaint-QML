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
                manualLayerChoose(idx)
                setLayerIndex(idx)
                rightPanelFunctions.propertiesBlockUpdate()
                blockRect.state = "layerSwap"
            }
            else {
                leftPanelFunctions.removeReplacers()
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
            leftPanelFunctions.removeLayer(index, true)
        }
    }
}
