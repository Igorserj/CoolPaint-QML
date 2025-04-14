import QtQuick 2.15

Item {
    Block {
        id: historyMenuBlock
        blockModel: historyMenuBlockModel
        function blockAction(index) {
            console.log(Object.entries(historyMenuBlockModel.get(1).block.get(index)))
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = historyMenuBlock
    }
}
