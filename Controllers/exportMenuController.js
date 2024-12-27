function exportDialogAccept(image, source, ext) {
    const path = source.toString().slice(7)
    const name = `${path.replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2')}.${ext[0]}`;
    console.log(name)
    image.grabToImage(result => result.saveToFile(name))
}
