import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: exportMenuBlock
        blockModel: exportMenuBlockModel
        function blockAction() {
            if (name === "Set source size") {
                const sizes = canva.getBaseImageDims()
                exportMenuModel.setProperty(0, "val1", sizes.sourceW)
                exportMenuModel.setProperty(1, "val1", sizes.sourceH)
                canva.setImageSize(sizes.sourceW, sizes.sourceH)
            } else if (name === "Apply") {
                canva.reDraw()
            } else if (name === "Export image") {
                exportFileDialog.open()
            } else if (name === "Close") {
                close()
            }
        }
    }
    Component.onCompleted: {
        // spacer.y = (parent.height - height) / 2
        spacer.upperBlock = exportMenuBlock
    }
}
