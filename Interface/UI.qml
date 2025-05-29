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
    WelcomeScreen {}
}
