import QtQuick 2.15

QtObject {
    property var listOfThemes: ['darkPurple', 'lightPurple', 'darkClassic', 'lightClassic', 'tranquil']
    property var currentTheme: this[listOfThemes[0]]

    readonly property var darkPurple: {
        "pinkWhite": "#AF9FAF",
        "pinkWhiteAccent": "#D4C4D4",
        "pinkWhiteDim": "#8F7F8F",
        "lightDark": strictStyle ? "#232323" : "#242424",
        "darkGlass": strictStyle ? "#2A2A2A" : "#5C000000",
        "darkGlassAccent": strictStyle ? "#696369" : "#5CAF9FAF",
        "darkGlassDim": strictStyle ? "#696369" : "#5C241424",
        "dark": "#1F0F1F",
        "vinous": "#302430",
        "vinousGlass": strictStyle ? "#6C536C" : "#5C9E619E",
        "whiteVeil": strictStyle ? "#434343" : "#25FFFFFF"
    }

    readonly property var lightPurple: {
        "pinkWhite": "#AF9FAF",
        "pinkWhiteAccent": "#D4C4D4",
        "pinkWhiteDim": "#8F7F8F",
        "lightDark": "#6F5F6F",
        "darkGlass": strictStyle ? "#908790" : "#5CAAAAAA",
        "darkGlassAccent": strictStyle ? "#AE9EAE" : "#5CCCCCCC",
        "darkGlassDim": strictStyle ? "#806E80" : "#5C948494",
        "dark": strictStyle ? "#8E7E8E" : "#8F7F8F",
        "vinous": "#604860",
        "vinousGlass": strictStyle ? "#957395" : "#5CCE85CE",
        "whiteVeil": strictStyle ? "#837583" : "#25FFFFFF"
    }

    readonly property var darkClassic: {
        "pinkWhite": "#B6B6B6",
        "pinkWhiteAccent": "#E6E6E6",
        "pinkWhiteDim": "#757575",
        "lightDark": "#1A1A1A",
        "darkGlass": strictStyle ? "#2E2E2E" : "#4D000000",
        "darkGlassAccent": strictStyle ? "#3B3B3B" : "#4D2C2C2C",
        "darkGlassDim": strictStyle ? "#454545" : "#4D4D4D4D",
        "dark": "#0A0A0A",
        "vinous": "#242424",
        "vinousGlass": strictStyle ? "#636363" : "#5C9E9E9E",
        "whiteVeil": strictStyle ? "#434343" : "#25FFFFFF"
    }

    readonly property var lightClassic: {
        "pinkWhite": "#656565",
        "pinkWhiteAccent": "#464646",
        "pinkWhiteDim": "#242424",
        "lightDark": "#E6E6E6",
        "darkGlass": strictStyle ? "#C3C3C3" : "#8DF4F4F4",
        "darkGlassAccent": strictStyle ? "#B5B5B5" : "#8DCDCDCD",
        "darkGlassDim": strictStyle ? "#B4B4B4" : "#8DD4D4D4",
        "dark": "#DFDFDF",
        "vinous": "#C4C4C4",
        "vinousGlass": strictStyle ? "#ACACAC" : "#5CAFAFAF",
        "whiteVeil": strictStyle ? "#A7A7A7" : "#24000000"
    }

    // readonly property var tranquil: {
    //     "pinkWhite": "#3F4F3F",
    //     "pinkWhiteAccent": "#556555",
    //     "pinkWhiteDim": "#253525",
    //     "lightDark": "#C9B5A9",//"#F5F5DC",// "#D2B48C",//"#A09589",
    //     "darkGlass": strictStyle ? "#B6B4A9" : "#5DDCDCDC",
    //     "darkGlassAccent": strictStyle ? "#BAC7AD" : "#5DE3FFE3",
    //     "darkGlassDim": strictStyle ? "#B1AFA3" : "#4DC5C5C5",
    //     "dark": "#C7CFC7",//"#BCC4BC",
    //     "vinous": "#AA9F94",
    //     "vinousGlass": strictStyle ? "#D0C5B9" : "#5DD0C5B9",
    //     "whiteVeil": strictStyle ? "#A19E8C" : "#8992BA81"
    // }
    readonly property var tranquil: {
        "pinkWhite": "#A9BA9D",
        "pinkWhiteAccent": "#83B9A3",
        "pinkWhiteDim": "#6C7C59",
        "lightDark": "#F0FFF0",
        "darkGlass": strictStyle ? "#76714F" : "#CA6F714E",
        "darkGlassAccent": strictStyle ? "#414335" : "#CA354230",
        "darkGlassDim": strictStyle ? "#857254" : "#344B6F44",
        "dark": "#634127",
        "vinous": "#826644",
        "vinousGlass": strictStyle ? "#275538" : "#CA0D5C33",
        "whiteVeil": strictStyle ? "#967359" : "#CA866449"
    }

    function setTheme(index) {
        currentTheme = this[listOfThemes[index]]
    }
}
