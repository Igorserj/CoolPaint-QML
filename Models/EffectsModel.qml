import QtQuick 2.15

ListModel {
    ListElement {
        name: "Color shift"
        isOverlay: false
        items: [
            ListElement {
                type: "joystick"
                name: "Red shift range"
                min1: -0.5
                min2: -0.5
                max1: 0.5
                max2: 0.5
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                type: "joystick"
                name: "Green shift range"
                min1: -0.5
                min2: -0.5
                max1: 0.5
                max2: 0.5
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                type: "joystick"
                name: "Blue shift range"
                min1: -0.5
                min2: -0.5
                max1: 0.5
                max2: 0.5
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            }
        ]
    }
    ListElement {
        name: "Vignette"
        isOverlay: true
        items: [
            ListElement {
                type: "slider"
                name: "Lower range"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                type: "slider"
                name: "Upper range"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                type: "joystick"
                name: "Center"
                min1: 0
                min2: 0
                max1: 1
                max2: 1
                val1: 0.5
                val2: 0.5
                bval1: 0.5
                bval2: 0.5
            },
            ListElement {
                type: "slider"
                name: "Roundness"
                min1: 0
                max1: 1
                val1: 1
                bval1: 1
            }
        ]
    }
    ListElement {
        name: "Saturation"
        isOverlay: false
        items: [
            ListElement {
                type: "joystick"
                name: "Strength"
                min1: -1
                min2: -1
                max1: 1
                max2: 1
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            }
        ]
    }
    ListElement {
        name: "Grain"
        isOverlay: true
        items: [
            ListElement {
                type: "slider"
                name: "Density"
                min1: 0
                max1: 10
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Black and white"
        isOverlay: true
        items: [
            ListElement {
                type: "slider"
                name: "Strength"
                min1: -1
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                type: "slider"
                name: "Threshold"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Motion blur"
        isOverlay: false
        items: [
            ListElement {
                type: "joystick"
                name: "Shift range"
                min1: -0.01
                min2: -0.01
                max1: 0.01
                max2: 0.01
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                type: "slider"
                name: "Density"
                min1: 2
                max1: 20
                val1: 2
                bval1: 2
            }
        ]
    }
    ListElement {
        name: "Tone map"
        isOverlay: true
        items: [
            ListElement {
                type: "slider"
                name: "Lower range"
                min1: 0
                max1: 0.5
                val1: 0
                bval1: 0
            },
            ListElement {
                type: "slider"
                name: "Upper range"
                min1: 0
                max1: 0.5
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Grid"
        isOverlay: true
        items: [
            ListElement {
                type: "slider"
                name: "Rows"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            },
            ListElement {
                type: "slider"
                name: "Columns"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            },
            ListElement {
                type: "joystick"
                name: "Cell position"
                min1: 1
                min2: 1
                max1: 11
                max2: 11
                val1: 1
                val2: 1
                bval1: 1
                bval2: 1
            }
        ]
    }
    ListElement {
        name: "Color curve"
        isOverlay: false
        items: [
            ListElement {
                type: "slider"
                name: "Red level"
                min1: 0
                max1: 2
                val1: 1
                bval1: 1
            },
            ListElement {
                type: "slider"
                name: "Green level"
                min1: 0
                max1: 2
                val1: 1
                bval1: 1
            },
            ListElement {
                type: "slider"
                name: "Blue level"
                min1: 0
                max1: 2
                val1: 1
                bval1: 1
            }
        ]
    }
    ListElement {
        name: "Overlay"
        isOverlay: false
        items: [
            ListElement {
                type: "insert"
                name: "Mask"
            },
            ListElement {
                type: "insert"
                name: "Image"
            }
        ]
    }
}
