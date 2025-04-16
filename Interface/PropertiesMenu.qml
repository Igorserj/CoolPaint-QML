import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: propertiesBlock
        blockModel: propertiesBlockModel
    }
    Block {
        id: viewsBlock
        y: parent.height / 2
        blockModel: viewsBlockModel
    }
    Component.onCompleted: {
        spacer.upperBlock = propertiesBlock
        spacer.lowerBlock = viewsBlock
    }
}
