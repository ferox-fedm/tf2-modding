require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5
local defaultMargin = hp

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("Credits", {
		backgroundColor = ssu.makeColor(0, 0, 0, 100)
	})
	
	a("Credits::Layout", {
		gravity = { -1.0, .0 }
	})
	
	a("Credits::Header1", {
		fontSize = 36,
		padding = { 8 * vp, hp, vp, hp }
	})
	
	a("Credits::Header2", {
		fontSize = 24,
		padding = { 4 * vp, hp, vp, hp }
	})
	
	a("Credits::Name, Credits::Link", {
		fontSize = 16,
		padding = { vp, hp, vp, hp },
		maxSize = { 1000, -1 },
		textAlignment = { 0.5, -1 }
	})
	
	a("Credits::License", {
		fontSize = 12,
		padding = { vp, hp, vp, hp },
		size = { 500, -1 },
		textAlignment = { 0, -1 },
		fontFamily = "Noto/NotoSansMono-Regular.ttf"
	})

	a("Credits::Link", {
		padding = { vp + 5, hp, vp + 10, hp },
		color = ssu.makeColor(132, 188, 221, 255)
	})
	
	a("Credits::Header1, Credits::Header2, Credits::Name, Credits::Link, Credits::License", {
		gravity = { .5, .0 }
	})

	return result
end
