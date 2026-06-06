local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/station/air/airfield/era_a_airfield_main_building.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 50, 110 },
	materialIndexMap = {
		[1] = "shared/asphalt_01.lua",
		[2] = "shared/grass_cutted_01.lua",
		[3] = "shared/grass_cutted_02.lua",
		[4] = "shared/gravel_03.lua",
		[5] = "shared/asphalt_04.lua",
	},
	priority = 14,
}
end
