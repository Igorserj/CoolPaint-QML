import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: historyMenuBlock
        y: window.height * 0.01
        blockModel: historyMenuBlockModel
        function blockAction(index) {
            console.log(Object.entries(historyMenuBlockModel.get(1).block.get(index)))
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = historyMenuBlock
    }
}
