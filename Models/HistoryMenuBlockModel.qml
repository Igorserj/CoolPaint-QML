import QtQuick 2.15

ListModel {
    ListElement {
        block: ListElement {
            wdth: 240
            type: "header"
            name: "History"
            view: "normal,overlay"
            category: "history"
        }
    }
    // onRowsInserted: {
    //     console.log("History",Object.entries(this.get(count-1)))
    // }
}
