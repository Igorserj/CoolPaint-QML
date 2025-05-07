import QtQuick 2.15

QtObject {
    property var listOfThemes: ['darkPurple', 'lightPurple', 'darkClassic']
    readonly property var currentTheme: this[listOfThemes[lightTheme]]
    //`#33${style.currentTheme.pinkWhiteDim.toString().substring(1)}`

    readonly property var darkPurple: {
        "pinkWhite": "#AF9FAF",
        "pinkWhiteAccent": "#D4C4D4",
        "pinkWhiteDim": "#8F7F8F",
        "lightDark": "#242424",
        "darkGlass": "#5C000000",
        "darkGlassAccent": "#5CAF9FAF",
        "darkGlassDim": "#5C241424",
        "dark": "#1F0F1F",
        "vinous": "#302430"
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
        "vinous": "#604860"
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
        "vinous": "#242424"
    }
}
