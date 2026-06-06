local tu = require "texutil"

function data()
return {
		
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/farm_grain_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),

	texSize = { 160, 120 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_brown.lua",
		[3] = "gravel_01.lua",
		[4] = "shared/grass_cutted_01.lua",
		[5] = "shared/water_dirty.lua",
		[6] = "shared/wheat.lua",
	},
	priority = 20,
}
end
