import QtQuick 2.15

ListModel {
    property var historyMenuBlockModel
    property var historyBlockModelGeneration

    onRowsInserted: {
        console.log(Object.entries(this.get(count-1)))
        if (count > 0) historyBlockModelGeneration(this, historyMenuBlockModel)
        autoSave()
    }
    function trimModel(index) {
        if (index + 1 < count) {
            console.log("trimmed", index + 1, count)
            this.remove(index + 1, count - (index + 1))
        }
    }
}
