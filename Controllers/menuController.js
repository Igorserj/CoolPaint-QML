function menuActions(index, openDialog, openProjectDialog, saveFileDialog, exportFileDialog) {
    switch (index) {
    case 0: openDialog.open(); break;
    case 1: openProjectDialog.open(); break;
    case 2: saveFileDialog.open(); break;
    case 3: /*exportFileDialog.open();*/console.log("zaglushka"); break;
    }
    // openFile, openProject, saveFile, exportFile
}

function openDialogAccept(canva, source) {
    canva.setImage(source)
}
