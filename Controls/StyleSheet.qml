import QtQuick 2.15

QtObject {
    property var listOfThemes: ['darkPurple', 'lightPurple', 'darkClassic', 'lightClassic', 'tranquil']
    property var currentTheme: this[listOfThemes[0]]
    //`#33${style.currentTheme.pinkWhiteDim.toString().substring(1)}`

    readonly property var darkPurple: {
        "pinkWhite": "#AF9FAF",
        "pinkWhiteAccent": "#D4C4D4",
        "pinkWhiteDim": "#8F7F8F",
        "lightDark": strictStyle ? "#341434" : "#242424",
        "darkGlass": strictStyle ? "#320032" : "#5C000000",
        "darkGlassAccent": strictStyle ? "#512251" : "#5CAF9FAF",
        "darkGlassDim": strictStyle ? "#241424" : "#5C241424",
        "dark": "#1F0F1F",
        "vinous": "#302430",
        "vinousGlass": strictStyle ? "#9E619E" : "#5C9E619E",
        "whiteVeil": strictStyle ? "#614e6f" : "#25FFFFFF"
    }

    readonly property var lightPurple: {
        "pinkWhite": "#AF9FAF",
        "pinkWhiteAccent": "#D4C4D4",
        "pinkWhiteDim": "#8F7F8F",
        "lightDark": "#6F5F6F",
        "darkGlass": "#5CAAAAAA",
        "darkGlassAccent": "#5CCCCCCC",
        "darkGlassDim": "#5C948494",
        "dark": "#8F7F8F",
        "vinous": "#604860",
        "vinousGlass": "#5CCE85CE",
        "whiteVeil": "#25FFFFFF"
    }

    readonly property var darkClassic: {
        "pinkWhite": "#B6B6B6",
        "pinkWhiteAccent": "#E6E6E6",
        "pinkWhiteDim": "#757575",
        "lightDark": "#1A1A1A",
        "darkGlass": "#4D000000",
        "darkGlassAccent": "#4D2C2C2C",
        "darkGlassDim": "#4D4D4D4D",
        "dark": "#0A0A0A",
        "vinous": "#242424",
        "vinousGlass": "#5C9E9E9E",
        "whiteVeil": "#25FFFFFF"
    }

    readonly property var lightClassic: {
        "pinkWhite": "#3F3F3F",
        "pinkWhiteAccent": strictStyle ? "#4A4A4A" : "#5A5A5A",
        "pinkWhiteDim": "#242424",
        "lightDark": "#E6E6E6",
        "darkGlass": strictStyle ? "#E4E4E4" : "#5DF4F4F4",
        "darkGlassAccent": strictStyle ? "#CDCDCD" : "#5DCDCDCD",
        "darkGlassDim": strictStyle ? "#D4D4D4" : "#4DD4D4D4",
        "dark": "#DFDFDF",
        "vinous": "#C4C4C4",
        "vinousGlass": strictStyle ? "#AFAFAF" : "#5CAFAFAF",
        "whiteVeil": strictStyle ? "#999999" : "#24000000"
    }

    readonly property var tranquil: {
        "pinkWhite": "#3F3F3F",
        "pinkWhiteAccent": "#5A5A5A",
        "pinkWhiteDim": "#242424",
        "lightDark": "#9e968f", //
        "darkGlass": "#5DE3E1D5",
        "darkGlassAccent": "#5DCDCDCD",
        "darkGlassDim": "#4DD4D4D4",
        "dark": "#DFDFDF",
        "vinous": "#C4C4C4",
        "vinousGlass": "#5CAFAFAF",
        "whiteVeil": "#24b2daa1" //
    }

    function setTheme(index) {
        currentTheme = this[listOfThemes[index]]
    }
}
