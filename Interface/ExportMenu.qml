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
    Block {
        id: settingsMenuBlock
        y: 0.5 * parent.height
        blockModel: settingsMenuBlockModel
        function blockAction(index) {
            let i = 0
            switch (name) {
            case "Save": {
                const model = { 'settings': [] }
                const settingsFile = `${baseDir}/settings.json`
                for (; i < settingsMenuBlockModel.get(1).block.count - 2; ++i) {
                    model.settings.push(settingsMenuBlockModel.get(1).block.get(i))
                }
                const jsonData = JSON.stringify(model, null, '\t')
                const result = fileIO.write(settingsFile, jsonData)
                lightTheme = settingsMenuBlockModel.get(1).block.get(1).val1 === 1
                console.log('Writing to', settingsFile, 'success:', result)
                break
            }
            case "Revert": {
                const settingsFile = `${baseDir}/settings.json`
                const data = fileIO.read(settingsFile)
                if (data !== "") {
                    const jsonData = JSON.parse(data)
                    for (; i < jsonData.settings.length; ++i) {
                        for (let j = 0; j < settingsMenuBlockModel.get(1).block.count; ++ j) {
                            if (settingsMenuBlockModel.get(1).block.get(j).name === jsonData.settings[i].name) {
                                settingsMenuBlockModel.get(1).block.setProperty(j, 'val1', parseInt(jsonData.settings[i].val1))
                                break
                            }
                        }
                    }
                }
                break
            }
            }
        }
    }
    Component.onCompleted: {
        spacer.upperBlock = exportMenuBlock
        spacer.lowerBlock = settingsMenuBlock
    }
}
