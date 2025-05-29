import QtQuick 2.15

ListModel {
    ListElement {
        module: [
            ListElement {
                block: ListElement {
                    wdth: 240
                    type: "header"
                    name: "Actions"
                    view: "normal,overlay"
                    category: "welcome"
                }
            }
        ]
    }
    ListElement {
        module: ListElement {
            block: ListElement {
                wdth: 240
                type: "header"
                name: "Recent projects"
                view: "normal,overlay"
                category: "welcome"
            }
        }
    }
    ListElement {
        module: ListElement {
            block: ListElement {
                wdth: 240
                type: "header"
                name: "Backup projects"
                view: "normal,overlay"
                category: "welcome"
            }
        }
    }
}
