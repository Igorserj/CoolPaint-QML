import QtQuick 2.15

ListModel {
    ListElement {
        name: "Count of autosaves"
        type: "slider"
        category: "settings"
        val1: 5
        val2: 0
        bval1: 5
        max1: 10
        min1: 0
        items: []
    }
    ListElement {
        name: "UI Effects"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        max1: 1
        val1: 0
        val2: 0
        bval1: 0
        items: []
    }
    ListElement {
        name: "Strict style"
        type: "buttonSwitch"
        category: "settings"
        min1: 0
        max1: 1
        val1: 0
        val2: 0
        bval1: 0
        items: []
    }
    ListElement {
        name: "Lights"
        type: "insertDropdown"
        category: "settings"
        min1: 0
        max1: 3
        val1: 0
        val2: 0
        bval1: 0
        items: []
    }
    ListElement {
        name: "Revert"
        type: "buttonDark"
        category: "settings"
        val1: 0
        val2: 0
        bval1: 0
        max1: 1
        min1: 0
        wdth: 240
        items: []
    }
    ListElement {
        name: "Apply and save"
        type: "buttonDark"
        category: "settings"
        val1: 0
        val2: 0
        bval1: 0
        max1: 1
        min1: 0
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
            case "Lights": newModel.theme = [i, this.get(i).val1]; break
            case "Count of autosaves": newModel.autosaves = [i, this.get(i).val1]; break
            case "UI Effects": newModel.effects = [i, this.get(i).val1]; break
            case "Strict style": newModel.style = [i, this.get(i).val1]; break
            }
        }
        return newModel
    }
}
