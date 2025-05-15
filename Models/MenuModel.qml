import QtQuick 2.15

ListModel {
    ListElement {
        type: "buttonDark"
        wdth: 180
        name: "Open"
        val1: 0
        val2: 0
    }
    ListElement {
        type: "buttonDark"
        wdth: 180
        name: "Open project"
        val1: 0
        val2: 0
    }
    ListElement {
        type: "buttonDark"
        wdth: 180
        name: "Save as"
        val1: 0
        val2: 0
    }
    ListElement {
        type: "buttonDark"
        wdth: 180
        name: "Export"
        val1: 0
        val2: 0
    }
    // onRowsInserted: {
    //     console.log("Menu",Object.entries(this.get(count-1)))
    // }
}
