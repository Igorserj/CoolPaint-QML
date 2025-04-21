import QtQuick 2.15

QtObject {
    property color pinkWhite: "#AF9FAF"
    property color pinkWhiteAccent: "#D4C4D4"
    property color pinkWhiteDim: "#8F7F8F"
    property color lightDark: !lightTheme ? "#242424" : "#6F5F6F"
    property color darkGlass: !lightTheme ? "#5C000000" : "#5CAAAAAA"
    property color darkGlassAccent: !lightTheme ? "#5CAF9FAF" : "#5CCCCCCC"
    property color darkGlassDim: !lightTheme ? "#5C241424" : "#5C948494"
    property color dark: !lightTheme ? "#1F0F1F" : "#8F7F8F"
    property color vinous: !lightTheme ? "#302430" : "#604860"
    //`#33${style.pinkWhiteDim.toString().substring(1)}`
}
