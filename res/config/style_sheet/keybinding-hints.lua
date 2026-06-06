require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
    local result = {}

    local a = ssu.makeAdder(result)

    local pathXBOX = "ui/input_devices/xbox/"
    local pathPS4 = "ui/input_devices/ps4/"
    local pathPS5 = "ui/input_devices/ps5/"

    a("KeybindingHintCombo::Layout, KeybindingHintDisplay::Layout", {
		innerSpacing = {0, 0}, 
		outerSpacing = {0, 0}
	})

    a("KeybindingHintDisplay", {
        padding = {1, 1, 1, 1}
        -- backgroundColor1 = ssu.makeColor(0, 0, 255, 50),
        -- backgroundImage1 = { fileName = "ui/design/buttons/disk_mini_surface.tga", horizontal = { 0, 12, 12, 24 }, vertical = { 0, 12, 12, 24 } },
    })

    a("KeybindingHintDisplay!overflowMode", {
        gravity = {0.0, 0.5} -- Position relative to parent ContentView. Special: this places the Hint's center!
    })

	a("Button KeybindingHintDisplay!overflowMode", {
		margin = { 0, 3, 0, 3 }
	})

    a("LineList !newline KeybindingHintDisplay!overflowMode",
      {gravity = {1.0, 0.5}}
	)

    a("!manager-win !table-item-selectable KeybindingHintDisplay!overflowMode",
      {gravity = {0.9, 0.5}}
	)

    a("!entry-icon KeybindingHintDisplay!overflowMode", {
		gravity = {0.9, 0.25}}
	)

    a("!module-list-item KeybindingHintDisplay!overflowMode", {
		gravity = {0.85, 0.25}}
	)

    a("!entry-icon", {
        gravity = {0.0, 0.5} -- this is needed to avoid it defaulting to the layout's -1 | -1
    })

    a("KeyBindingHintAnd, KeyBindingHintOr", {padding = {0, 0, 0, 0}})

    a("KeybindingHintCombo", { -- one of the key binding Combos
        minSize = {-1, 32}
    })

    a("KeybindingHintKeyboard", {
        textAlignment = {0.5, 0.5},
        padding = {vp, hp, vp, hp},
        fontSize = ssu.styles.uicouch_body_fontSize,
        backgroundColor1 = ssu.makeColor(0, 0, 0, 153),
        backgroundImage1 = {
            fileName = "ui/design/buttons/disk_mini_surface.tga",
            horizontal = {0, 12, 12, 24},
            vertical = {0, 12, 12, 24}
        },
        backgroundColor2 = ssu.makeColor(255, 255, 255, 255),
        backgroundImage2 = {
            fileName = "ui/design/buttons/disk_mini_contour.tga",
            horizontal = {0, 12, 12, 24},
            vertical = {0, 12, 12, 24}
        }
    })

    a("KeybindingHintIcon", {
        size = {32, 32},
        backgroundColor1 = ssu.makeColor(15, 35, 50),
        backgroundColor2 = ssu.makeColor(255, 255, 255),
        borderColor = ssu.makeColor(255, 255, 255, 255)
    })
    a("KeybindingHintIcon:disabled, KeybindingHintKeyboard:disabled", {
        backgroundColor2 = ssu.makeColor(150, 150, 150),
		borderColor = ssu.makeColor(150, 150, 150),
    })

    -- XBox --
    a("!gamepad-type-xbox KeybindingHintIcon!none", {
        -- backgroundImage2 = { fileName = pathXBOX .. "none.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad", {
        backgroundImage1 = { fileName = pathXBOX.."dpad/dpad_surface.tga" },
        borderImage = { fileName = pathXBOX.."dpad/dpad_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!upwards", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_up.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!rightwards", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_right.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!downwards", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_down.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!leftwards", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_left.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!x", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_x.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad!y", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad_y.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!dpad", {
        backgroundImage2 = { fileName = pathXBOX .. "dpad/dpad.tga" }
    })


    a("!gamepad-type-xbox KeybindingHintIcon!face", {
        backgroundImage1 = { fileName = pathXBOX .. "face/face_surface.tga" },
        borderImage = { fileName = pathXBOX .. "face/face_contour.tga"  }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!face!upwards", {
        backgroundImage2 = { fileName = pathXBOX .. "face/face_up.tga" },
        backgroundColor2 = ssu.makeColor(240, 194, 53),
        borderColor = ssu.makeColor(240, 194, 53)
    })

    a("!gamepad-type-xbox KeybindingHintIcon!face!rightwards", {
        backgroundImage2 = { fileName = pathXBOX .. "face/face_right.tga" },
        backgroundColor2 = ssu.makeColor(206, 51, 33),
        borderColor = ssu.makeColor(206, 51, 33)
    })

    a("!gamepad-type-xbox KeybindingHintIcon!face!downwards", {
        backgroundImage2 = { fileName = pathXBOX .. "face/face_down.tga" },
        backgroundColor2 = ssu.makeColor(104, 132, 16),
        borderColor = ssu.makeColor(104, 132, 16)
    })

    a("!gamepad-type-xbox KeybindingHintIcon!face!leftwards", {
        backgroundImage2 = { fileName = pathXBOX .. "face/face_left.tga" },
        backgroundColor2 = ssu.makeColor(46, 102, 215),
        borderColor = ssu.makeColor(46, 102, 215)
    })

    a("!gamepad-type-xbox KeybindingHintIcon!left!shoulder", {
        backgroundImage2 = { fileName = pathXBOX .. "shoulder/leftshoulder.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "shoulder/leftshoulder_surface.tga" },
        borderImage = { fileName = pathXBOX .. "shoulder/leftshoulder_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!right!shoulder", {
        backgroundImage2 = { fileName = pathXBOX .. "shoulder/rightshoulder.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "shoulder/rightshoulder_surface.tga" },
        borderImage = { fileName = pathXBOX .. "shoulder/rightshoulder_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!left!trigger", {
        backgroundImage2 = { fileName = pathXBOX .. "trigger/lefttrigger.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "trigger/lefttrigger_surface.tga" },
        borderImage = { fileName = pathXBOX .. "trigger/lefttrigger_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!right!trigger", {
        backgroundImage2 = { fileName = pathXBOX .. "trigger/righttrigger.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "trigger/righttrigger_surface.tga" },
        borderImage = { fileName = pathXBOX .. "trigger/righttrigger_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick!push", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_push.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_push_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick!push", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_push.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_push_contour.tga" }
    })


    a("!gamepad-type-xbox KeybindingHintIcon!special1", {
        backgroundImage2 = { fileName = pathXBOX .. "options/options.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "face/face_surface.tga" },
        borderImage = { fileName = pathXBOX .. "face/face_contour.tga"  }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!special2", {
        backgroundImage2 = { fileName = pathXBOX .. "view/view.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "face/face_surface.tga" },
        borderImage = { fileName = pathXBOX .. "face/face_contour.tga"  }
    })


    a("!gamepad-type-xbox KeybindingHintIcon!stick", {
        backgroundImage1 = { fileName = pathXBOX .. "stick/face_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/face_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick!upwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_up.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick!rightwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_right.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick!leftwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_left.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!left!stick!downwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_down.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!left!stick", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!left!stick!x", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_x.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!left!stick!y", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/leftstick_y.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_contour.tga" }
    })
    
    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick!upwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_up.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick!rightwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_right.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick!leftwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_left.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!button!right!stick!downwards", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_down.tga" },
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!right!stick", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathXBOX .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathXBOX .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!right!stick!x", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_x.tga" }
    })

    a("!gamepad-type-xbox KeybindingHintIcon!axis!right!stick!y", {
        backgroundImage2 = { fileName = pathXBOX .. "stick/rightstick_y.tga" }
    })

    a([[!gamepad-type-xbox KeybindingHintIcon!face!upwards:disabled,
        !gamepad-type-xbox KeybindingHintIcon!face!rightwards:disabled,
        !gamepad-type-xbox KeybindingHintIcon!face!downwards:disabled,
        !gamepad-type-xbox KeybindingHintIcon!face!leftwards:disabled]], {
        backgroundColor2 = ssu.makeColor(150, 150, 150),
        borderColor = ssu.makeColor(150, 150, 150),
    })

    -- PlayStation 5 --
    a("!gamepad-type-playstation5 KeybindingHintIcon!none", {
        -- backgroundImage2 = { fileName = "ui/input_devices/ps/none.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad", {
        backgroundImage1 = { fileName = pathPS5.."dpad/dpad_surface.tga" },
        borderImage = { fileName = pathPS5.."dpad/dpad_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!upwards", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_up.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!rightwards", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_right.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!downwards", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_down.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!leftwards", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_left.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!x", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_x.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad!y", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad_y.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!dpad", {
        backgroundImage2 = { fileName = pathPS5 .. "dpad/dpad.tga" }
    })


    a("!gamepad-type-playstation5 KeybindingHintIcon!face", {
        backgroundImage1 = { fileName = pathPS5 .. "face/face_surface.tga" },
        borderImage = { fileName = pathPS5 .. "face/face_contour.tga"  }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!face!upwards", {
        backgroundImage2 = { fileName = pathPS5 .. "face/face_up.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!face!rightwards", {
        backgroundImage2 = { fileName = pathPS5 .. "face/face_right.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!face!downwards", {
        backgroundImage2 = { fileName = pathPS5 .. "face/face_down.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!face!leftwards", {
        backgroundImage2 = { fileName = pathPS5 .. "face/face_left.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!left!shoulder", {
        backgroundImage2 = { fileName = pathPS5 .. "shoulder/leftshoulder.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "shoulder/leftshoulder_surface.tga" },
        borderImage = { fileName = pathPS5 .. "shoulder/leftshoulder_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!right!shoulder", {
        backgroundImage2 = { fileName = pathPS5 .. "shoulder/rightshoulder.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "shoulder/rightshoulder_surface.tga" },
        borderImage = { fileName = pathPS5 .. "shoulder/rightshoulder_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!left!trigger", {
        backgroundImage2 = { fileName = pathPS5 .. "trigger/lefttrigger.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "trigger/lefttrigger_surface.tga" },
        borderImage = { fileName = pathPS5 .. "trigger/lefttrigger_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!right!trigger", {
        backgroundImage2 = { fileName = pathPS5 .. "trigger/righttrigger.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "trigger/righttrigger_surface.tga" },
        borderImage = { fileName = pathPS5 .. "trigger/righttrigger_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick!push", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_push.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_push_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick!push", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_push.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_push_contour.tga" }
    })


    a("!gamepad-type-playstation5 KeybindingHintIcon!special1", {
        backgroundImage2 = { fileName = pathPS5 .. "options/options.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "options/options_surface.tga" },
        borderImage = { fileName = pathPS5 .. "options/options_contour.tga"  }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!special2", {
        --backgroundImage2 = { fileName = pathPS5 .. "touchpad/vtouchpad.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "touchpad/touchpad_surface.tga" },
        borderImage = { fileName = pathPS5 .. "touchpad/touchpad_contour.tga"  }
    })


    a("!gamepad-type-playstation5 KeybindingHintIcon!stick", {
        backgroundImage1 = { fileName = pathPS5 .. "stick/face_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/face_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick!upwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_up.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick!rightwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_right.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick!leftwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_left.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!left!stick!downwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_down.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!left!stick", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!left!stick!x", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_x.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!left!stick!y", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/leftstick_y.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_contour.tga" }
    })
    
    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick!upwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_up.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick!rightwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_right.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick!leftwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_left.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!button!right!stick!downwards", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_down.tga" },
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!right!stick", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS5 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS5 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!right!stick!x", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_x.tga" }
    })

    a("!gamepad-type-playstation5 KeybindingHintIcon!axis!right!stick!y", {
        backgroundImage2 = { fileName = pathPS5 .. "stick/rightstick_y.tga" }
    })

    -- PlayStation 4 --
    a("!gamepad-type-playstation4 KeybindingHintIcon!none", {
        -- backgroundImage2 = { fileName = "ui/input_devices/ps/none.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad", {
        backgroundImage1 = { fileName = pathPS4.."dpad/dpad_surface.tga" },
        borderImage = { fileName = pathPS4.."dpad/dpad_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!upwards", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_up.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!rightwards", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_right.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!downwards", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_down.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!leftwards", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_left.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!x", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_x.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad!y", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad_y.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!dpad", {
        backgroundImage2 = { fileName = pathPS4 .. "dpad/dpad.tga" }
    })


    a("!gamepad-type-playstation4 KeybindingHintIcon!face", {
        backgroundImage1 = { fileName = pathPS4 .. "face/face_surface.tga" },
        borderImage = { fileName = pathPS4 .. "face/face_contour.tga"  }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!face!upwards", {
        backgroundImage2 = { fileName = pathPS4 .. "face/face_up.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!face!rightwards", {
        backgroundImage2 = { fileName = pathPS4 .. "face/face_right.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!face!downwards", {
        backgroundImage2 = { fileName = pathPS4 .. "face/face_down.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!face!leftwards", {
        backgroundImage2 = { fileName = pathPS4 .. "face/face_left.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!left!shoulder", {
        backgroundImage2 = { fileName = pathPS4 .. "shoulder/leftshoulder.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "shoulder/leftshoulder_surface.tga" },
        borderImage = { fileName = pathPS4 .. "shoulder/leftshoulder_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!right!shoulder", {
        backgroundImage2 = { fileName = pathPS4 .. "shoulder/rightshoulder.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "shoulder/rightshoulder_surface.tga" },
        borderImage = { fileName = pathPS4 .. "shoulder/rightshoulder_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!left!trigger", {
        backgroundImage2 = { fileName = pathPS4 .. "trigger/lefttrigger.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "trigger/lefttrigger_surface.tga" },
        borderImage = { fileName = pathPS4 .. "trigger/lefttrigger_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!right!trigger", {
        backgroundImage2 = { fileName = pathPS4 .. "trigger/righttrigger.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "trigger/righttrigger_surface.tga" },
        borderImage = { fileName = pathPS4 .. "trigger/righttrigger_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick!push", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_push.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_push_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick!push", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_push.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_push_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_push_contour.tga" }
    })


    a("!gamepad-type-playstation4 KeybindingHintIcon!special1", {
        backgroundImage2 = { fileName = pathPS4 .. "options/options.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "options/options_surface.tga" },
        borderImage = { fileName = pathPS4 .. "options/options_contour.tga"  }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!special2", {
        --backgroundImage2 = { fileName = pathPS4 .. "touchpad/vtouchpad.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "touchpad/touchpad_surface.tga" },
        borderImage = { fileName = pathPS4 .. "touchpad/touchpad_contour.tga"  }
    })


    a("!gamepad-type-playstation4 KeybindingHintIcon!stick", {
        backgroundImage1 = { fileName = pathPS4 .. "stick/face_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/face_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick!upwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_up.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick!rightwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_right.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick!leftwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_left.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!left!stick!downwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_down.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!left!stick", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!left!stick!x", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_x.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!left!stick!y", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/leftstick_y.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick!upwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_up.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick!rightwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_right.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick!leftwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_left.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!button!right!stick!downwards", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_down.tga" },
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!right!stick", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_xy.tga" },
        backgroundImage1 = { fileName = pathPS4 .. "stick/stick_surface.tga" },
        borderImage = { fileName = pathPS4 .. "stick/stick_contour.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!right!stick!x", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_x.tga" }
    })

    a("!gamepad-type-playstation4 KeybindingHintIcon!axis!right!stick!y", {
        backgroundImage2 = { fileName = pathPS4 .. "stick/rightstick_y.tga" }
    })

    return result
end
