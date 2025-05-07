import QtQuick 2.15
import "../Controls"

Item {
    property alias propertiesBlock: propertiesBlock
    Block {
        id: propertiesBlock
        blockModel: propertiesBlockModel
        function blockAction() {}
    }
    Block {
        id: viewsBlock
        y: parent.height / 2
        blockModel: viewsBlockModel
        function blockAction() {}
    }
    Component.onCompleted: {
        spacer.upperBlock = propertiesBlock
        spacer.lowerBlock = viewsBlock
    }
}
