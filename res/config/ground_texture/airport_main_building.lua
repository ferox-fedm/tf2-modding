local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/station/air/airport/era_b_airport_main_building.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 120, 155 },
	materialIndexMap = {
		[1] = "shared/asphalt_01.lua",
		[2] = "shared/asphalt_02.lua",
		[3] = "shared/asphalt_05.lua",
		[4] = "shared/grass_cutted_01.lua",
	},
	priority = 14,
}
end
