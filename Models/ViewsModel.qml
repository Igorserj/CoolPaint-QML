import QtQuick 2.15

ListModel {
    ListElement {
        type: "slider"
        wdth: 240
        name: "Scale"
        category: "view"
        val1: 1.
        val2: 0
        min1: 0.
        max1: 5.
        bval1: 1.
        isOverlay: false
    }
    ListElement {
        type: "buttonSwitch"
        wdth: 240
        name: "Mirroring"
        category: "view"
        val1: 0
        val2: 0
        min1: 0
        max1: 1
        bval1: 0
        isOverlay: false
    }
    ListElement {
        type: "buttonSwitch"
        wdth: 240
        name: "Smoothing"
        category: "view"
        val1: 0
        val2: 0
        min1: 0
        max1: 1
        bval1: 0
        isOverlay: false
    }
    ListElement {
        type: "buttonSwitch"
        wdth: 240
        name: "Show preview"
        category: "view"
        val1: 1
        val2: 0
        min1: 0
        max1: 1
        bval1: 1
        isOverlay: false
    }
}
