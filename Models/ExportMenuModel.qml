import QtQuick 2.15

ListModel {
    ListElement {
        name: "Width"
        type: "slider"
        category: "export"
        val1: 0
        val2: 0
        bval1: 0
        max1: 0
        min1: 0
    }
    ListElement {
        name: "Height"
        type: "slider"
        category: "export"
        val1: 0
        val2: 0
        bval1: 0
        max1: 0
        min1: 0
    }
    ListElement {
        name: "Preserve aspect fit"
        type: "buttonSwitch"
        category: "export"
        val1: 1
        val2: 0
        bval1: 1
        max1: 1
        min1: 0
    }
    ListElement {
        name: "Set source size"
        type: "buttonDark"
        category: "export"
        val1: 0
        val2: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
    }
    ListElement {
        name: "Apply"
        type: "buttonDark"
        category: "export"
        val1: 0
        val2: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
    }
    ListElement {
        name: "Export image"
        type: "buttonDark"
        category: "export"
        val1: 0
        val2: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
    }
}
