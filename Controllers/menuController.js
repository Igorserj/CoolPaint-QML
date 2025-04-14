function menuActions(index, openDialog, openProjectDialog, saveFileDialog, exportFileDialog) {
    switch (index) {
    case 0: openDialog.open(); break;
    case 1: openProjectDialog.open(); break;
    case 2: saveFileDialog.open(); break;
    case 3: exportFileDialog.switchState(); break;
    }
}

function openDialogAccept(canva, source, layersModel, exportModel) {
    canva.setImage(source)
    if (layersModel.count > 0) canva.reDraw()
    const sizes = canva.getBaseImageDims()
    exportModel.set(0, {
                        'bval1': sizes.aspectW,
                        'val1': sizes.width,
                        "max1": sizes.sourceW > sizes.aspectW * 1.5 ? sizes.sourceW : sizes.aspectW * 1.5,
                        "min1": sizes.sourceW < sizes.aspectW / 1.5 ? sizes.sourceW : sizes.aspectW / 1.5
                    })

    exportModel.set(1, {
                        'bval1': sizes.aspectH,
                        'val1': sizes.height,
                        "max1": sizes.sourceH > sizes.aspectH * 1.5 ? sizes.sourceH : sizes.aspectH * 1.5,
                        "min1": sizes.sourceH < sizes.aspectH / 1.5 ? sizes.sourceH : sizes.aspectH / 1.5
                    })
}
