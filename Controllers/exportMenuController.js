function exportDialogAccept(image, source, ext) {
    const path = source.toString().slice('file:///'.length)
    const name = `${path.replace(/^(.+?)\.[^.]*$|^([^.]+)$/, '$1$2')}.${ext[0]}`;
    if (image !== null && image.width !== 0 && image.height !== 0) {
        image.grabToImage(result => result.saveToFile(name))
    } else {
        const notificationText = 'Unable to export image: item has invalid dimensions'
        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
    }
}
