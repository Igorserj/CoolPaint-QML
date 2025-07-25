import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: historyMenuBlock
        y: window.height * 0.01
        blockModel: historyMenuBlockModel
        function blockAction(index) {
            if (type === "filter") {
                historyBlockModelGeneration(index)
                addReplacerToHistory()
            }
        }
    }
    Block {
        id: metadataMenuBlock
        y: 0.5 * parent.height + window.height * 0.01
        blockModel: metadataMenuBlockModel
        function blockAction(index) {
            if (type === "filter") {
                metadataFilterChoose(name)
            }
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = historyMenuBlock
        spacer.lowerBlock = metadataMenuBlock
    }
}
