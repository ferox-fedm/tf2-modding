require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("#guidesystem.window", {
		backgroundColor = ssu.makeColor(83, 151, 198, 200),
		shadowColor = ssu.makeColor(255, 255, 255, 100),
		blurRadius = 4 * 4
	})
	a("!input-controller #guidesystem.window Window::Close!close-button", {
	    visibility = "none"
	})
	a("#guidesystem.window:enabled", {
		soundEffect1 = sound.get("guidesystem")
	})
	a("#guidesystem.window Window::Icon", {
		color = ssu.makeColor(255, 255, 50)
	})
	a("#guidesystem.textView", {
		padding = { 2 * vp, hp, 3 * vp, hp }
	})
	
	return result
end
