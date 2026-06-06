require "tableutil"
local ssu = require "stylesheetutil"

local contentPadding = 10

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("#contexthelper.window", {
		backgroundColor = ssu.makeColor(70, 83, 93, 150),
		minSize = { 400, 400 },
		anchorPoint = { 0, 1 },
	})

	a("!ui-couch #contexthelper.window", {
		anchorPoint = { 0.5, 0.5 },
	})
	
	a("#contexthelper.window Window::Title-bar", {
		--backgroundColor = ssu.makeColor(70, 83, 93, 128),
		--backgroundImage1 = { fileName = "ui/design/game-menu/shadow_window.tga" },
		--backgroundColor1 = ssu.makeColor(5, 25, 40),
		--borderWidth = { 0, 0, 1, 0},
		--borderColor = ssu.makeColor(5, 25, 40),
		minSize = { 32, 32 }
	})
	
	a("#contexthelper.textView", {
		padding = { 10, 10, 10, 10 }
	})
	
	return result
end
