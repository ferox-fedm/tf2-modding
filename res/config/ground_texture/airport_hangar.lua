local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/station/air/airport/era_b_airport_hangar.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 80, 155 },
	materialIndexMap = {
		[0] = "shared/asphalt_01.lua",
		[1] = "shared/asphalt_02.lua",
		[2] = "shared/asphalt_03.lua",
		[3] = "shared/asphalt_05.lua",
		[4] = "shared/water_dirty.lua",
	},
	priority = 14,
}
end
