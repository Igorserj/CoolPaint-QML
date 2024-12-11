import QtQuick 2.15

ListModel {

    function getModel(idx, iteration = -1, mode = 'default') {
        const newModel = []
        for (let i = 0; i < this.count; ++i) {
            if (this.get(i).idx === idx && this.get(i).iteration === iteration) {
                switch (mode) {
                case 'default': newModel.push(this.get(i)); break
                case 'index': newModel.push(i); break
                }
            } else if (iteration === -1 && this.get(i).idx === idx) {
                switch (mode) {
                case 'default': newModel.push(this.get(i)); break
                case 'index': newModel.push(i); break
                }
            }
        }
        return newModel
    }
}
