import QtQuick 2.15
import Qt.labs.platform 1.1
import "Controls"
import "Models"
import "Controllers/exportMenuController.js" as Controller

Item {
    Loader {
        id: exportMenuLoader
        width: window.width / 1280 * 260
        height: window.height
    }
    Component {
        id: expMenu
        Rectangle {
            color: "#302430"
            MouseArea {
                anchors.fill: parent
            }
            Block {
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
        }
    }
    FileDialog {
        id: exportFileDialog
        nameFilters: ["Joint Photographic Experts Group (*.jpeg)", /*"Digital Negative Specification (*.dng)", */"Tagged Image File Format (*.tiff)", "Portable Network Graphics (*.png)", "Bitmap Picture (*.bmp)"]
        fileMode: FileDialog.SaveFile
        selectedNameFilter.index: 0
        onAccepted: Controller.exportDialogAccept(canva.finalImage, currentFile, selectedNameFilter.extensions)
    }
    ExportMenuBlockModel {id: exportMenuBlockModel}
    StyleSheet {id: style}

    function open() {
        const sizes = canva.getBaseImageDims()
        exportMenuModel.set(0,
                            {
                                "val1": sizes.width,
                                "max1": sizes.sourceW > sizes.aspectW * 1.5 ? sizes.sourceW : sizes.aspectW * 1.5,
                                "min1": sizes.sourceW < sizes.aspectW / 1.5 ? sizes.sourceW : sizes.aspectW / 1.5
                            }
                            )
        exportMenuModel.set(1,
                            {
                                "val1": sizes.height,
                                "max1": sizes.sourceH > sizes.aspectH * 1.5 ? sizes.sourceH : sizes.aspectH * 1.5,
                                "min1": sizes.sourceH < sizes.aspectH / 1.5 ? sizes.sourceH : sizes.aspectH / 1.5
                            }
                            )
            exportMenuBlockModel.set(1, {'block': []})
        for (let i = 0; i < exportMenuModel.count; ++i) {
            exportMenuBlockModel.get(1).block.append(exportMenuModel.get(i))
        }
        exportMenuLoader.sourceComponent = expMenu
    }
    function close() {
        exportMenuLoader.sourceComponent = undefined
    }
}
