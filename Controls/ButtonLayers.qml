import QtQuick 2.15

ButtonDark {
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
        enabled: name !== "Overlay"
        text: "ᚖ"
        function clickAction() {
            // moveLayer(index, colArea)
            if (blockRect.state !== "layerSwap") blockRect.state = "layerSwap"
            else blockRect.state = "enabled"
        }
    }
}
