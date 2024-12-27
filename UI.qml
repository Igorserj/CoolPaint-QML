import QtQuick 2.15
import "Controls"

Item {
    property alias rightPanel: rightPanel
    property alias canva: canva
    Background {}
    Canva {id: canva}
    LeftPanel {id: leftPanel}
    RightPanel {id: rightPanel}
    Menu {}
    ExportMenu {id: exportMenu}
    ValueDialog {
        id: valueDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
}
