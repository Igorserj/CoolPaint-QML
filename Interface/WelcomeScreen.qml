import QtQuick 2.15
import "../Controls"
import "../Controllers/welcomeScreenController.js" as Controller
import "../Models"

Rectangle {
    id: welcomeScreen
    width: parent.width
    height: parent.height
    color: window.style.currentTheme.lightDark
    state: "actions"
    states: [
        State {
            name: "actions"
            PropertyChanges {
                target: hiding
                running: false
            }
            PropertyChanges {
                target: revealing
                running: true
            }
        },
        State {
            name: "settings"
            PropertyChanges {
                target: hiding
                running: false
            }
            PropertyChanges {
                target: revealing
                running: true
            }
        },
        State {
            name: "about"
            PropertyChanges {
                target: hiding
                running: false
            }
            PropertyChanges {
                target: revealing
                running: true
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: revealing
                running: false
            }
            PropertyChanges {
                target: hiding
                running: true
            }
        }
    ]
    Component.onCompleted: {
        Controller.welcomeModelPopulation(welcomeModel, welcomeBlockModel, undefined, getState)
        popUpPopulation()
    }

    SequentialAnimation {
        id: hiding
        PropertyAnimation {
            target: welcomeScreen
            property: "x"
            to: -welcomeScreen.width
            duration: strictStyle ? 0 : 700
            easing.type: Easing.InOutQuad
        }
        PropertyAction {
            target: welcomeScreen
            property: "visible"
            value: false
        }
    }
    SequentialAnimation {
        id: revealing
        PropertyAction {
            target: welcomeScreen
            property: "visible"
            value: true
        }
        PropertyAnimation {
            target: welcomeScreen
            property: "x"
            to: 0
            duration: strictStyle ? 0 : 700
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
    }
    Label {
        id: welcomeLabel
        text: "Welcome to CoolPaint"
        w: parent.width / 20
        x: (parent.width - width) / 2
        y: parent.height * 0.01
        centered: true
    }
    ButtonWhite {
        text: "⨯"
        w: 60
        x: parent.width - width - window.width * 0.01
        y: welcomeLabel.y + (welcomeLabel.height - height) / 2
        function clickAction() {
            if (leftPanelFunctions.getState() === "export") {
                leftPanelFunctions.populateSettings()
            }
            setState("disabled")
        }
    }
    Rectangle {
        id: welcomeContainer
        y: parent.height * 0.125
        height: parent.height * 0.75
        width: parent.width
        color: "transparent"
        Row {
            Repeater {
                model: welcomeBlockModel
                Rectangle {
                    id: moduleRect
                    property int moduleIndex: index
                    width: welcomeContainer.width / welcomeBlockModel.count
                    height: welcomeContainer.height
                    color: "transparent"
                    Block {
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * 0.96
                        blockModel: module
                        function blockAction(_, doubleClick) {
                            if (moduleIndex === 0) {
                                switch (getState()) {
                                case "actions": {
                                    if (name === "Settings") {
                                        setState("settings")
                                        Controller.welcomeModelPopulation(welcomeModel, welcomeBlockModel, settingsMenuModel, getState)
                                    } else if (name === "About") {
                                        setState("about")
                                        Controller.welcomeModelPopulation(welcomeModel, welcomeBlockModel, undefined, getState)
                                    } else if (name === "Quit") {
                                        closeWindow()
                                    } else if (name === "Open project") {
                                        popUpFunctions.openProjectDialog((currentFile) => openProj(currentFile))
                                    } else if (name === "Create project") {
                                        createProject()
                                    }
                                    break
                                }
                                case "settings": {
                                    settingsBlockAction(index, name, settingsMenuModel, welcomeBlockModel.get(0).module)
                                    break
                                }
                                case "about": {
                                    if (name === 'GNU General Public License') {
                                        Qt.openUrlExternally("https://www.gnu.org/licenses/gpl-3.0.en.html")
                                    } else if (name === "GitHub") {
                                        Qt.openUrlExternally("https://github.com/Igorserj/CoolPaint-QML")
                                    }
                                    break
                                }
                                }
                                if (name === "Actions") {
                                    setState("actions")
                                    Controller.welcomeModelPopulation(welcomeModel, welcomeBlockModel, undefined, getState)
                                }
                            } else if (moduleIndex === 1 || moduleIndex === 2) {
                                if (name === "Open project" || doubleClick) {
                                    const currentFile = val[0].startsWith('file://') ? val[0] : Qt.resolvedUrl(`file://${val[0]}`)
                                    const data = fileIO.read(currentFile)
                                    if (data !== "") {
                                        popUpFunctions.openedFileHandle(data, currentFile)
                                        openProj(currentFile)
                                    } else {
                                        const notificationText = "Selected file is empty or does not exist"
                                        popUpFunctions.openNotification(notificationText, notificationText.length * 100)
                                    }
                                    if (moduleIndex === 2) { projectSaved = false }
                                } else if (name === "Delete") {
                                    popUpFunctions.openDialog(`Delete project ${type}?`, "", [{text: "Delete", type: "Delete project", func: [index, moduleIndex, ...val]}, {text: "Cancel", func: "close"}])
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    WelcomeBlockModel {
        id: welcomeBlockModel
    }

    function getState() {
        return state
    }
    function setState(newState) {
        state = newState
    }
    function openProj(currentFile) {
        setState("disabled")
        projectSaved = true
    }
    function deleteProject(index, moduleIndex, file, image) {
        welcomeBlockModel.get(moduleIndex).module.get(1).block.remove(index)
        fileIO.removeFile(file)
        fileIO.removeFile(image)
        removeSavedProject(`file://${file}`)
    }
    function updatePopulation() {
        Controller.updatePopulation(welcomeModel, welcomeBlockModel, settingsMenuModel, getState, setState)
    }
    function popUpPopulation() {
        popUpFunctions.openProj = (currentFile) => openProj(currentFile)
        popUpFunctions.deleteProject = (index, moduleIndex, file, image) => deleteProject(index, moduleIndex, file, image)
        popUpFunctions.setWelcomeState = (newState) => setState(newState)
        popUpFunctions.goHome = () => {
            // setState("actions")
            revealing.start()
            updatePopulation()
        }
    }
}
