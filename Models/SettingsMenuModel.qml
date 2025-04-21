import QtQuick 2.15

ListModel {
    ListElement {
        name: "Count of autosaves"
        type: "slider"
        category: "settings"
        val1: 5
        bval1: 5
        max1: 10
        min1: 0
    }
    ListElement {
        name: "Lights"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        max1: 1
        val1: 0
        bval1: 0
    }
    ListElement {
        name: "Revert"
        type: "buttonDark"
        category: "settings"
        val1: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
    }
    ListElement {
        name: "Save"
        type: "buttonDark"
        category: "settings"
        val1: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
    }
}
