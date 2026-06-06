require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("VehicleTag", {
		padding = { 1, 2, 1, 2 },
	})
	
	a("VehicleTag::CountLabel", {
		fontSize = 12,
		textAlignment = { .5, 1.0 },
		padding = { -2, 1, -2, 0 },
		backgroundColor = ssu.makeColor(20, 20, 20, 230)
	})
	a("!ui-couch VehicleTag::CountLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("VehicleTag::ReplaceVehicle", {
		backgroundColor1 = ssu.makeColor(214, 214, 214),
		backgroundImage1 = { fileName = "ui/replace-vehicle-button-background.tga", horizontal = { 0, 2, 18, 20 }, vertical = { 0, 2, 18, 20 } },
	})
	
	return result
end
