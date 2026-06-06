require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local contentPadding = 0
local hp = 10
local vp = 5

local m = 100

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("ReleaseNotes", {
		gravity = { .0, -1.0 },
		blurRadius = 16 * 2,
		backgroundColor = ssu.makeColor(5, 25, 40, 175),
		-- borderWidth = { 10, 10, 10, 10},
		-- borderColor = ssu.makeColor(20, 27, 88, 100),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		shadowColor = ssu.makeColor(255, 255, 255),
		size = { 1250, 680 }
	})

	a("ReleaseNotes::Title", {
		fontSize = 24,
		textTransform = "UPPERCASE",
		-- padding = { 5, 2*contentPadding, 5, hp + contentPadding }, -- use if placed on left
		padding = { vp, 0, vp, hp + 60},
		gravity = { .5, .5 },
		-- backgroundColor = ssu.makeColor(5, 25, 40, 175),
		-- size = { -1, 50 },
	})
	a("!ui-couch ReleaseNotes::Title", {
		fontSize = ssu.styles.uicouch_window_title_fontSize,
		textTransform = ssu.styles.uicouch_window_title_textTransform,
	})

	a("ReleaseNotes::Title::Layout", {
		gravity = {-1, .5},
		backgroundColor = ssu.makeColor(5, 25, 40, 175),
	})

	a("ReleaseNotes::BottomLayout", {
		gravity = { .5, .5 },
		padding = { 0, 0, 10, 0},
	})

	a("!ui-couch ReleaseNotes::BottomLayout", {
		gravity = { 1, .5 },
		padding = { 0, 0, 10, 0},
	})

	a("ReleaseNotes::Item::Title", {
		fontSize = 26,
		-- padding = { vp + 25, hp, 0, hp + contentPadding/2}, -- enable if text on left
		padding = { vp + 10, 0, 5, 0 }, -- enable if text in the middle
		-- textTransform = "UPPERCASE", 
		-- backgroundColor = ssu.makeColor(5, 25, 40, 130),
		gravity = { 0.5, 0.5 }
	})

	a("!ui-couch ReleaseNotes ScrollArea::Content > wrap", {
		margin = { -20, 0, 0, 0 }
	})

	a("!ui-couch ReleaseNotes::Item::Title", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize,
		padding = { vp + 20, 0, 0, 0 },
	})

	a("ReleaseNotes::Item::Title::Layout", {
		-- backgroundColor = ssu.makeColor(5, 25, 40, 130),
		-- gravity = {-1, -1}
	})

	a("ReleaseNotes::Item::InfoTextLeft", {
		padding = { vp, hp, vp, 0 },
		fontSize = 16,
		-- backgroundColor = ssu.makeColor(10, 25, 40, 130),
		-- gravity = { .0, .0}
	})
	a("!ui-couch ReleaseNotes::Item::InfoTextLeft", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("ReleaseNotes::Item::InfoTextRight", {
		padding = { vp, 0, vp, hp },
		fontSize = 16,
		-- backgroundColor = ssu.makeColor(10, 25, 40, 130),
		-- gravity = { .0, .0}
	})
	a("!ui-couch ReleaseNotes::Item::InfoTextRight", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("ReleaseNotes::Item::InfoTextOnly", {
		padding = { vp + 25, hp, vp, hp },
		fontSize = 16,
		-- backgroundColor = ssu.makeColor(10, 25, 40, 130),
	})
	a("!ui-couch ReleaseNotes::Item::InfoTextOnly", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("ReleaseNotes::Item::ImageLeft", {
		-- scaling = .6,
		padding = { vp, hp, vp, hp + contentPadding },
		-- borderColor = ssu.makeColor(50, 25, 40, 100),
		-- borderWidth = { 5, 5, 5, 5 }
		-- gravity = { -1, -1}
		minSize = {640, 161},
		-- minSize = {500,200},
		-- maxSize = {750,200}
	})

	a("ReleaseNotes::Item::ImageRight", {
		-- scaling = .6,
		padding = { vp, hp + contentPadding, vp, hp },
		borderColor = ssu.makeColor(150, 125, 40, 100),
		-- borderWidth = { 5, 5, 5, 25 }
		-- gravity = { -1, -1}
		minSize = {640, 161},
		-- minSize = {500,200},
		-- maxSize = {750,200}
	})

	a("ReleaseNotes::Item::ImageMiddle", {
		--scaling = .6,
		padding = { 40, 0, 0, 0 },
		gravity = { 0.5, 0.5 },
		size = {960, 256},
		-- borderColor = ssu.makeColor(50, 25, 40, 100),
		-- borderWidth = { 5, 5, 5, 5 }
		-- gravity = { -1, -1}
	})

	a("ReleaseNotes::OkButton, ReleaseNotes::ShowButton", {
		minSize = {-1, 40},
	})
	a("!ui-couch ReleaseNotes::BottomLayout > BoxLayout", {
		innerSpacing = { 50, 0 },
		outerSpacing = { 25, 0 },
	})
	a("!ui-classic  ReleaseNotes::OkButton", {
		margin = { 0, 0, 0, 80 }
	})
	a("ReleaseNotes::BottomLayout KeybindingHintDisplay!overflowMode", {
		margin = { 0, -6, 0, 0 }
	})

	a("!input-mouse ReleaseNotes::OkButton, !input-mouse ReleaseNotes::ShowButton", {
        backgroundImage1 = {
            fileName = "ui/news_dialog_box/pill_behind.tga",
            horizontal = {0, 20, 130, 150},
            vertical = {0, 19, 21, 40}
        },
        backgroundImage2 = {
            fileName = "ui/news_dialog_box/pill_surface.tga",
            horizontal = {0, 20, 130, 150},
            vertical = {0, 19, 21, 40}
        },
        borderImage = {
            fileName = "ui/news_dialog_box/pill_contour.tga",
            horizontal = {0, 20, 130, 150},
            vertical = {0, 19, 21, 40}
        },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50),
		borderColor = ssu.makeColor(255, 255, 255, 128),
	})

	a("ReleaseNotes::PageTab TabWidget::IndicatorLayout", {
		gravity = { 0.5, 1.0},
	})

	a("!ui-couch ReleaseNotes::PageTab KeybindingHintDisplay", {
		visibility = "none"
	})

	a("!release-notes-button-text", {
		gravity = {-1, -1},
		margin = { vp, vp, vp, vp },
		textAlignment = {0.5, 0.5},
		fontSize = 15,
		textTransform = "UPPERCASE"
	})
	a("!ui-couch !release-notes-button-text", {
		fontSize = ssu.styles.uicouch_primarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_primarybuttons_textTransform
	})

	a("ReleaseNotes::OkButton:hover, ReleaseNotes::ShowButton:hover", {
		-- backgroundColor = ssu.makeColor(255, 255, 255, 50),
		-- borderColor = ssu.makeColor(255, 255, 255, 50)
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255),
		soundEffect1 = sound.get("buttonHover")
	})
	a("ReleaseNotes::OkButton:active, ReleaseNotes::ShowButton:active", {
		-- backgroundColor = ssu.makeColor(255, 255, 255, 100),
		-- borderColor = ssu.makeColor(255, 255, 255, 150)
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(110, 122, 132),
		soundEffect1 = sound.get("buttonClick")
	})

	a("ReleaseNotes::CheckBox:hover", {
		soundEffect1 = sound.get("buttonHover")
	})
	a("ReleaseNotes::CheckBox:active", {
		soundEffect1 = sound.get("toggleOn"),
		soundEffect2 = sound.get("toggleOff")
	})
	a("ReleaseNotes::CheckBox", {
		-- fontSize = 12,
		margin = { vp, 0, vp, 20 },
		backgroundColor1 = ssu.makeColor(255, 255, 255)
	})
	a("ReleaseNotes::CheckBox:hover", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100)
	})
	a("ReleaseNotes::CheckBox:active", {
		backgroundColor1 = ssu.makeColor(255, 255, 255)
	})
	a("ReleaseNotes::CheckBox:disabled", {
		backgroundColor1 = ssu.makeColor(150, 150, 150)
	})

	a("!tab-widget-release-notes", {
		backgroundImage1 = { fileName = "ui/news_dialog_box/disk_behind.tga" },
		backgroundImage2 = { fileName = "ui/news_dialog_box/disk_surface.tga" },
		borderImage = { fileName = "ui/news_dialog_box/disk_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50),
		borderColor = ssu.makeColor(255, 255, 255, 128),
		-- padding = { 0, 25, 0, 25 },
		-- borderWidth = { 5, 5, 5, 5 },
		-- minSize = { 15, 15 },
		-- maxSize = { 20, 20 }
		size = {22, 22}
	})
	a("!tab-widget-release-notes:hover", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255),
		soundEffect1 = sound.get("buttonHover")
	})
	a("!tab-widget-release-notes:active", {
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(110, 122, 132),
		soundEffect1 = sound.get("tabClick")
	})
	a("!tab-widget-release-notes:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})

	a("ReleaseNotes::CloseButton ImageView", {
		--borderColor = ssu.makeColor(5, 25, 40),
		--borderWidth = { 0, 0, 0, 1 }
	})
	a("ReleaseNotes::CloseButton ImageView:hover", {
		backgroundColor = ssu.makeColor(200, 0, 0, 200),
		soundEffect1 = sound.get("buttonHover")
	})
	a("ReleaseNotes::CloseButton ImageView:active", {
		backgroundColor = ssu.makeColor(255, 75, 75, 100),
		soundEffect1 = sound.get("buttonClick")
	})
	a("ReleaseNotes::CloseButton ImageView:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("!ui-couch ReleaseNotes::CloseButton", {
		visibility = "hidden"
	})

	return result
end
