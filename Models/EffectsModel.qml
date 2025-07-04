import QtQuick 2.15

ListModel {
    ListElement {
        name: "Color shift"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Red shift range"
                view: "normal,overlay"
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
                category: "layer"
                type: "joystick"
                name: "Green shift range"
                view: "normal,overlay"
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
                category: "layer"
                type: "joystick"
                name: "Blue shift range"
                view: "normal,overlay"
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
                category: "layer"
                type: "slider"
                name: "Lower range"
                view: "normal,overlay"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Upper range"
                view: "normal,overlay"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Center"
                view: "normal,overlay"
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
                category: "layer"
                type: "slider"
                name: "Roundness"
                view: "normal,overlay"
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
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: -1
                min2: -1
                max1: 1
                max2: 1
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Tone:"
                view: "normal"
                min1: -1
                min2: -1
                max1: 2
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
                category: "layer"
                type: "slider"
                name: "Density"
                view: "normal,overlay"
                min1: 0
                max1: 10
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Lower range"
                view: "overlay"
                min1: 0
                max1: 1.0
                val1: 0.98
                bval1: 0.98
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Upper range"
                view: "overlay"
                min1: 0
                max1: 1
                val1: 0.93
                bval1: 0.93
            }
        ]
    }
    ListElement {
        name: "Black and white"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal"
                min1: -1
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Threshold"
                view: "normal,overlay"
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
                category: "layer"
                type: "joystick"
                name: "Shift range"
                view: "normal,overlay"
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
                category: "layer"
                type: "slider"
                name: "Density"
                view: "normal,overlay"
                min1: 2
                max1: 20
                val1: 2
                bval1: 2
            }
        ]
    }
    ListElement {
        name: "Gaussian blur"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Radius"
                view: "normal,overlay"
                min1: 0
                max1: 15.
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Gaussian unblur"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Radius"
                view: "normal,overlay"
                min1: 0.
                max1: 2.
                val1: 0.
                bval1: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Amount"
                view: "normal,overlay"
                min1: 0.
                max1: 1.5
                val1: 0.
                bval1: 0.
            }
        ]
    }
    ListElement {
        name: "Tone map"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Lower range"
                view: "normal,overlay"
                min1: 0
                max1: 0.5
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Upper range"
                view: "normal,overlay"
                min1: 0
                max1: 0.5
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Grid"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Rows"
                view: "normal,overlay"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Columns"
                view: "normal,overlay"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            }
        ]
    }
    ListElement {
        name: "Grid section"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Rows"
                view: "normal,overlay"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Columns"
                view: "normal,overlay"
                min1: 1
                max1: 10
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Cell position"
                view: "overlay"
                min1: 0
                min2: 0
                max1: 1
                max2: 1
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Fixed position"
                view: "normal,overlay"
                min1: 0
                max1: 1
                val1: 1
                bval1: 1
            }
        ]
    }
    ListElement {
        name: "Color curve"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Red level"
                view: "normal,overlay"
                min1: 0
                max1: 2
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Green level"
                view: "normal,overlay"
                min1: 0
                max1: 2
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Blue level"
                view: "normal,overlay"
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
                category: "layer"
                type: "insertButton"
                name: "Mask"
            },
            ListElement {
                category: "layer"
                type: "insertButton"
                name: "Effect"
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Blending mode:"
            },
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Sharp mask"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Opacity"
                min1: 0
                max1: 1
                val1: 1
                bval1: 1
            }
        ]
    }
    ListElement {
        name: "Mirror"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Horizontal flip"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Vertical flip"
                min1: 0
                max1: 1
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Color highlight"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Pixel chooser"
                view: "normal,overlay"
                min1: 0
                min2: 0
                max1: 1
                max2: 1
                val1: 0
                val2: 0
                bval1: 0
                bval2: 0
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Tolerance"
                view: "normal,overlay"
                min1: 0
                max1: 0.3
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Blur"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Radius"
                view: "normal,overlay"
                min1: 0
                max1: 15.
                val1: 0
                bval1: 0
            }
        ]
    }
    ListElement {
        name: "Unblur"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Radius"
                view: "normal,overlay"
                min1: 0.
                max1: 2.
                val1: 0.
                bval1: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Amount"
                view: "normal,overlay"
                min1: 0.
                max1: 1.5
                val1: 0.
                bval1: 0.
            }
        ]
    }
    ListElement {
        name: "Rotation"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Angle"
                view: "normal,overlay"
                min1: 0
                max1: 360.
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Center"
                view: "normal,overlay"
                min1: 0
                min2: 0
                max1: 1.
                max2: 1.
                val1: 0.5
                val2: 0.5
                bval1: 0.5
                bval2: 0.5
            }
        ]
    }
    ListElement {
        name: "Negative"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: 0.
                max1: 1.
                val1: 0.
                bval1: 0.
            }
        ]
    }
    ListElement {
        name: "Combination mask"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "insertButton"
                name: "Mask"
            },
            ListElement {
                category: "layer"
                type: "insertButton"
                name: "Mask"
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Opacity"
                view: "normal,overlay"
                min1: 0.
                max1: 1.
                val1: 0.
                bval1: 0.
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Blending mode:"
            }
        ]
    }
    ListElement {
        name: "Color fill"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Color auto determination"
                view: "normal"
                min1: 0.
                min2: 0.
                max1: 1.
                max2: 0.
                val1: 0.
                val2: 0.
                bval1: 0.
                bval2: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Red"
                view: "normal"
                min1: 0.
                min2: 0.
                max1: 255.
                max2: 0.
                val1: 255.
                val2: 0.
                bval1: 255.
                bval2: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Green"
                view: "normal"
                min1: 0.
                min2: 0.
                max1: 255.
                max2: 0.
                val1: 255.
                val2: 0.
                bval1: 255.
                bval2: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Blue"
                view: "normal"
                min1: 0.
                min2: 0.
                max1: 255.
                max2: 0.
                val1: 255.
                val2: 0.
                bval1: 255.
                bval2: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Alpha"
                view: "normal,overlay"
                min1: 0.
                min2: 0.
                max1: 255.
                max2: 0.
                val1: 255.
                val2: 0.
                bval1: 255.
                bval2: 0.
            },
            ListElement {
                category: "layer"
                type: "joystick"
                name: "Pixel chooser"
                view: "normal"
                min1: 0.
                min2: 0.
                max1: 1.
                max2: 1.
                val1: 0.
                val2: 0.
                bval1: 0.
                bval2: 0.
            }
        ]
    }
    ListElement {
        name: "Gamma correction"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "buttonSwitch"
                name: "Encode"
                view: "normal,overlay"
                min1: 0.
                max1: 1.
                val1: 1.
                bval1: 1.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Gamma"
                view: "normal,overlay"
                min1: 1.
                max1: 2.33
                val1: 1.
                bval1: 1.
            }
        ]
    }
    ListElement {
        name: "Contrast correction"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: 0.
                max1: 5.
                val1: 1.
                bval1: 1.
            }
        ]
    }
    ListElement {
        name: "Brightness correction"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: -1.
                max1: 1.
                val1: 0.
                bval1: 0.
            }
        ]
    }
    ListElement {
        name: "Color swap"
        isOverlay: true
        items: [
            ListElement {
                category: "layer"
                type: "empty"
                name: ""
                view: ""
                min1: 0
                max1: 0
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "empty"
                name: ""
                view: ""
                min1: 0
                max1: 0
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Red channel"
                view: "normal"
                min1: 0
                max1: 3
                val1: 0
                bval1: 0
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Green channel"
                view: "normal"
                min1: 0
                max1: 3
                val1: 1
                bval1: 1
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Blue channel"
                view: "normal"
                min1: 0
                max1: 3
                val1: 2
                bval1: 2
            },
            ListElement {
                category: "layer"
                type: "insertDropdown"
                name: "Alpha channel"
                view: "normal,overlay"
                min1: 0
                max1: 3
                val1: 3
                bval1: 3
            }
        ]
    }
    ListElement {
        name: "Pixelation"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: 0.
                max1: 1.
                val1: 0.
                bval1: 0.
            }
        ]
    }
    ListElement {
        name: "Pixel sharpness"
        isOverlay: false
        items: [
            ListElement {
                category: "layer"
                type: "slider"
                name: "Strength"
                view: "normal,overlay"
                min1: 0.
                max1: 1.
                val1: 0.
                bval1: 0.
            },
            ListElement {
                category: "layer"
                type: "slider"
                name: "Amount"
                view: "normal,overlay"
                min1: 0.
                max1: 1.5
                val1: 0.
                bval1: 0.
            }
        ]
    }
}
