import QtQuick 2.15

Rectangle {
    id: textBlock
    property string text: ""
    property int w: 240
    property bool containsMouse: textArea.containsMouse
    width: biggerSide * w
    height: textText.height + window.height * 0.04
    color: window.style.currentTheme.darkGlass
    radius: strictStyle ? 0 : width / 24
    Text {
        id: textText
        text: parent.text
        font.family: "Helvetica"
        font.bold: true
        color: window.style.currentTheme.pinkWhiteAccent
        font.pixelSize: w / 19
        wrapMode: Text.Wrap
        width: biggerSide * w * 0.9
        x: (parent.width - width) / 2
        y: window.height * 0.02
        lineHeight: 1.2
        horizontalAlignment: width > contentWidth ? Text.AlignHCenter : Text.AlignLeft
    }
    MouseArea {
        id: textArea
        hoverEnabled: true
        anchors.fill: parent
    }
}

