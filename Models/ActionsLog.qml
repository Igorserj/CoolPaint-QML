import QtQuick 2.15

ListModel {
    property var historyMenuBlockModel
    property var historyBlockModelGeneration
    function trimModel(index) {
        if (index + 1 < count) {
            this.remove(index + 1, count - (index + 1))
        }
    }
}
