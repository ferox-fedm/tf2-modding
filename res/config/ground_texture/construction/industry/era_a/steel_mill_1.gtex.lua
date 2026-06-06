local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/steel_mill_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 213.535, 154.374 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "shared/asphalt_01.lua",
		[3] = "shared/asphalt_02.lua",
		[4] = "shared/asphalt_03.lua",
		[5] = "shared/ballast.lua",
		[6] = "shared/gravel_03.lua",
		[7] = "shared/gravel_04.lua",
		[8] = "shared/soil_01.lua",
		[9] = "shared/water_dirty.lua",
	},
	priority = 20,
}
end
