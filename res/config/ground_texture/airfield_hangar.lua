local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/station/air/airfield/era_a_airfield_hangar.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 50, 110 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "shared/gravel_03.lua",
		[3] = "shared/asphalt_04.lua",
	},
	priority = 14,
}
end
