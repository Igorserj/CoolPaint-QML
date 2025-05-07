import QtQuick 2.15
import "../Controls"

Item {
    property bool imageAssigned: false
    anchors.fill: parent
    Background {}
    Canva {}
    LeftPanel {}
    RightPanel {}
    ActionBar {}
    Menu {}
    ValueDialog {
        id: valueDialog
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        Component.onCompleted: {
            popUpFunctions.closeValueDialog = close
            popUpFunctions.openValueDialog = open
        }
    }
    Notification {
        id: notification
        Component.onCompleted: {
            popUpFunctions.openNotification = open
            popUpFunctions.closeNotification = close
        }
    }
}
