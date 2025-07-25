import QtQuick 2.15

ListModel {
    ListElement {
        name: "Count of autosaves"
        type: "slider"
        category: "settings"
        min1: 0
        min2: 0
        max1: 10
        max2: 0
        val1: 5
        val2: 0
        bval1: 5
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "UI Effects"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        min2: 0
        max1: 1
        max2: 0
        val1: 0
        val2: 0
        bval1: 0
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Strict style"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        min2: 0
        max1: 1
        max2: 0
        val1: 0
        val2: 0
        bval1: 0
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "WIP: async render"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        min2: 0
        max1: 1
        max2: 0
        val1: 1
        val2: 0
        bval1: 1
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Color scheme"
        type: "insertDropdown"
        category: "settings"
        min1: 0
        min2: 0
        max1: 4
        max2: 0
        val1: 0
        val2: 0
        bval1: 0
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Checkerboard density"
        type: "slider"
        category: "settings"
        min1: -1
        min2: 0
        max1: 100
        max2: 0
        val1: -1
        val2: 0
        bval1: -1
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Revert"
        type: "buttonDark"
        category: "settings"
        min1: 0
        min2: 0
        max1: 1
        max2: 0
        val1: 0
        val2: 0
        bval1: 0
        bval2: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Apply and save"
        type: "buttonDark"
        category: "settings"
        min1: 0
        min2: 0
        max1: 1
        max2: 0
        val1: 0
        val2: 0
        bval1: 0
        bval2: 0
        wdth: 240
        items: []
    }
    function getModel(name, mode = 'default') {
        const newModel = []
        for (let i = 0; i < this.count; ++i) {
            if (this.get(i).name === name) {
                switch (mode) {
                case 'default': newModel.push(this.get(i)); break
                case 'index': newModel.push(i); break
                }
            }
        }
        return newModel
    }
    function getValues() {
        const newModel = {
            "theme": [],
            "autosaves": [],
            "effects": []
        }
        for (let i = 0; i < this.count; ++i) {
            switch (this.get(i).name) {
            case "Color scheme": newModel.theme = [i, this.get(i).val1]; break
            case "Count of autosaves": newModel.autosaves = [i, this.get(i).val1]; break
            case "UI Effects": newModel.effects = [i, this.get(i).val1]; break
            case "Strict style": newModel.style = [i, this.get(i).val1]; break
            case "WIP: async render": newModel.render = [i, this.get(i).val1]; break
            case "Checkerboard density": newModel.density = [i, this.get(i).val1]; break
            }
        }
        return newModel
    }
}
