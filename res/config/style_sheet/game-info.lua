require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("#gameInfo.earningsComp.earnings", {
		size = { 120, -1 },
		textAlignment = { 1.0, .5 },
		textAutoScale = true,
	})
	a("!ui-couch #gameInfo.earningsComp.earnings", {
		size = { 130, -1 },
	})
	
	a("#gameInfo.passengerComp.numPassenger, #gameInfo.cargoComp.numCargo", {
		size = { 75, -1 },
		textAlignment = { 1.0, .5 }
	})
	
	a("#gameInfo TextView", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("#gameInfo.layout", {
		innerSpacing = { hp, vp }
	})
	
	return result
end
