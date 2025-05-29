import QtQuick 2.15
import "../Controls"

Item {
    Block {
        id: exportMenuBlock
        y: window.height * 0.01
        blockModel: exportMenuBlockModel
        function blockAction() {
            switch (name) {
            case "Set source size": {
                const sizes = canvaFunctions.getBaseImageDims()
                exportMenuModel.setProperty(0, "val1", sizes.sourceW)
                exportMenuModel.setProperty(1, "val1", sizes.sourceH)
                canvaFunctions.setImageSize(sizes.sourceW, sizes.sourceH)
                break
            }
            case "Apply": {
                canvaFunctions.reDraw()
                break
            }
            case "Export image": {
                exportFileDialog.open()
                break
            }
            case "Close": {
                close()
                break
            }
            }
        }
    }
    Block {
        id: settingsMenuBlock
        y: 0.5 * parent.height + window.height * 0.01
        blockModel: settingsMenuBlockModel
        function blockAction(index) {
            settingsBlockAction(index, name, settingsMenuModel, settingsMenuBlockModel)
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = exportMenuBlock
        spacer.lowerBlock = settingsMenuBlock
    }
}
