import QtQuick 2.15

ListModel {
    ListElement {
        block: ListElement {
            wdth: 240
            type: "header"
            name: "Properties"
            view: "normal,overlay"
        }
    }
    // onRowsInserted: {
    //     console.log("Props",Object.entries(this.get(count-1)))
    // }
}
