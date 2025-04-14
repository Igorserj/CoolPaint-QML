import QtQuick 2.15
import "Controls"

Item {
    property alias rightPanel: rightPanel
    property alias canva: canva
    property alias actionBar: actionBar
    anchors.fill: parent
    Background {}
    Canva {id: canva}
    LeftPanel {id: leftPanel}
    RightPanel {id: rightPanel}
    ActionBar {
        id: actionBar
    }
    Menu {}
    ValueDialog {
        id: valueDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
}
