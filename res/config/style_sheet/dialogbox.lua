require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("DialogBox::Overlay", {
		backgroundColor = ssu.makeColor(0, 0, 0, 0)
	})
	
	a("DialogBox::Title", {
		textTransform = "UPPERCASE",
		padding = { vp, hp, vp, hp }
	})
	
	a("DialogBox::Text", {
		padding = { vp * 2, hp, vp * 2, hp }
	})
	a("!ui-couch DialogBox::Text", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("DialogBox::Layout", {
		gravity = { -1.0, -1.0 }
	})

	a("!ui-couch DialogBox Button", {
		margin = { 15, 0, 5, 70 },
	})
	a([[DialogBox Button KeybindingHintDisplay!overflowMode,
		MenuWindow::Buttons Button!right-button KeybindingHintDisplay!overflowMode]], {
		margin = { 0, -3, 0, 0 },
	})

	a("DialogBox::Content", {
		minSize = { 200, 125 },
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		shadowColor = ssu.makeColor(255, 255, 255),
	})
	
	a("Window!dialog-manager DialogBox::Content", {
		shadowColor = ssu.makeColor(0, 0, 0, 0),
	})

	a("Window!dialog-manager", {
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
		shadowColor = ssu.makeColor(255, 255, 255),
		blurRadius = 4 * 4
	})
	a("Window!dialog-manager DialogBox::Text", {
		padding = { 0, 10, 0, 10},
	})

	return result
end
