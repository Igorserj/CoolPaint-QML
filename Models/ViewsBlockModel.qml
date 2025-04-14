import QtQuick 2.15

ListModel {
    ListElement {
        block: ListElement {
            wdth: 240
            type: "header"
            name: "View"
            view: "normal,overlay"
            category: "view"
        }
    }
    // onRowsInserted: {
    //     console.log("Views",Object.entries(this.get(count-1)))
    // }
}
