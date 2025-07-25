import QtQuick 2.15

Rectangle {
    id: slot
    property int w: 240
    property int slotIndex: index
    width: biggerSide * w
    height: column.height + biggerSide * 13
    color: window.style.currentTheme.whiteVeil
    radius: strictStyle ? 0 : width / 24
    Column {
        id: column
        y: biggerSide * 6.5
        spacing: biggerSide * 6.5
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            id: mainContainer
            x: (parent.width - width) / 2
            width: biggerSide * (w - 10)
            height: overlayFolder.y + overlayFolder.height + biggerSide * 6.5
            color: window.style.currentTheme.darkGlass
            radius: strictStyle ? 0 : width / 24
            state: "closed"
            states: [
                State {
                    name: "opened"
                    when: !foldableArea.inProcess && overlayFolder.state === "down"
                    PropertyChanges {
                        target: imageContainer
                        height: mainContainer.width * 0.85
                        width: mainContainer.width * 0.85
                        x: (mainContainer.width - imageContainer.width) / 2
                    }
                    PropertyChanges {
                        target: nameText
                        opacity: 0
                    }
                },
                State {
                    name: "closed"
                    when: foldableArea.inProcess || overlayFolder.state === "right"
                    PropertyChanges {
                        target: imageContainer
                        height: mainContainer.width * 0.425
                        width: mainContainer.width * 0.425
                        x: mainContainer.width * (0.5 - 0.4625)
                    }
                    PropertyChanges {
                        target: nameText
                        opacity: 1
                    }
                }
            ]
            Rectangle {
                id: imageContainer
                color: window.style.currentTheme.dark
                radius: strictStyle ? 0 : width / 12
                y: parent.width * (0.5 - 0.4625)
                state: "noImage"
                states: [
                    State {
                        name: "noImage"
                        when: !fileIO.exists(image)
                        PropertyChanges {
                            target: imgText
                            visible: true
                        }
                        PropertyChanges {
                            target: img
                            source: ""
                        }
                    },
                    State {
                        name: "imageExist"
                        when: fileIO.exists(image)
                        PropertyChanges {
                            target: imgText
                            visible: false
                        }
                        PropertyChanges {
                            target: img
                            source: image
                        }
                    }
                ]
                Behavior on x { NumberAnimation { duration: strictStyle ? 0 : 300 } }
                Behavior on width { NumberAnimation { duration: strictStyle ? 0 : 300 } }
                Behavior on height { NumberAnimation { duration: strictStyle ? 0 : 300 } }
                Text {
                    id: imgText
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: w / 16
                    text: "NO\nPREVIEW"
                    font.bold: true
                    wrapMode: Text.Wrap
                    color: window.style.currentTheme.pinkWhiteAccent
                }
                Image {
                    id: img
                    width: parent.width * 0.9
                    height: parent.height * 0.9
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: false
                }
            }
            Text {
                id: nameText
                text: name
                font.family: "Helvetica"
                font.bold: true
                color: window.style.currentTheme.pinkWhiteAccent
                font.pixelSize: w / 19
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                width: parent.width - (imageContainer.x + imageContainer.width) - biggerSide * 13
                height: parent.width * 0.425
                x: imageContainer.x + imageContainer.width + biggerSide * 6.5
                y: parent.width * (0.5 - 0.4625)
                Behavior on opacity { NumberAnimation { duration: strictStyle ? 0 : 150 } }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: "PointingHandCursor"
                onClicked: {
                    overlayFolder.folderAction()
                }
                onDoubleClicked: {
                    blockRect.clickAction(name, fileName, slotIndex, [path, img.source], true)
                }
            }
            OverlayFolder {
                id: overlayFolder
                anchors.horizontalCenter: parent.horizontalCenter
                state: "right"
                elide: state === "down" ? Text.ElideNone : Text.ElideLeft
                text: path
                w: 230
                y: imageContainer.y + imageContainer.height + biggerSide * 6.5
            }
        }
        Column {
            id: foldableArea
            property bool inProcess: opening.running || collapsing.running
            width: childrenRect.width
            height: 0
            spacing: biggerSide * 6.5
            clip: true
            state: "collapsed"
            states: [
                State {
                    name: "default"
                    PropertyChanges {
                        target: opening
                        running: true
                    }
                },
                State {
                    name: "collapsed"
                    PropertyChanges {
                        target: collapsing
                        running: true
                    }
                }
            ]
            SequentialAnimation {
                id: collapsing
                PropertyAnimation {
                    target: foldableArea
                    property: "height"
                    to: 0
                    duration: strictStyle ? 0 : 500
                }
            }
            SequentialAnimation {
                id: opening
                PropertyAnimation {
                    target: foldableArea
                    property: "height"
                    to: foldableArea.childrenRect.height
                    duration: strictStyle ? 0 : 500
                }
            }
            Repeater {
                model: options
                delegate: ButtonDark {
                    text: name
                    w: 230
                    function clickAction() {
                        blockRect.clickAction(name, fileName, slotIndex, [path, img.source], false)
                    }
                }
            }
        }
    }
    function setFoldState(state) {
        foldableArea.state = state
    }
    function getFoldState() {
        return foldableArea.state
    }
}

