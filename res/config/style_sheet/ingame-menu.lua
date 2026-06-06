require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5
local defaultMargin = hp

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("InGameMenuUI::Background", {
		backgroundColor = ssu.makeColor(0, 10, 20, 100),
	})
	
	a("InGameMenuUI::Buttons BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("InGameMenuUI::Buttons Button BoxLayout", {
		innerSpacing = { 15, 15 },
	})
	
	a("InGameMenuUI::Buttons Button", {
		padding = { 15, 15, 15, 15 },
		gravity = { -1.0, .5 }
	})
	a("InGameMenuUI::Buttons Button::Text", {
		fontSize = 28,
		textTransform = "UPPERCASE",
	})
	a("!ui-couch InGameMenuUI::Buttons Button::Text", {
		fontSize = ssu.styles.uicouch_ingamemenu_fontSize,
		textTransform = ssu.styles.uicouch_ingamemenu_textTransform,
	})
	a("!big-error-message", {
		backgroundColor = ssu.makeColor(255, 10, 10, 150),
		textTransform = "UPPERCASE",
		fontSize = 28,
		innerSpacing = { 15, 15 },
	})
	a("!ui-couch !big-error-message", {
		fontSize = ssu.styles.uicouch_ingamemenu_fontSize,
		textTransform = ssu.styles.uicouch_ingamemenu_textTransform,
	})

	a("MemoryUsage", {
		backgroundColor = ssu.makeColor(255, 10, 10, 150),
		innerSpacing = { 15, 15 },
	})

	return result
end
