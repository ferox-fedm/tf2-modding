require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("Window!game-dialog", {
		backgroundColor = ssu.makeColor(198, 99, 83, 200),
		shadowColor = ssu.makeColor(255, 255, 255, 100),
		blurRadius = 4 * 4
	})
	a("Window!game-dialog TextView", {
		padding = { 2 * vp, hp, 3 * vp, hp }
	})
	a("Window!game-dialog BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	return result
end
