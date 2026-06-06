local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/food_processing_plant_4.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 192, 170.103 },
	materialIndexMap = {
		[1] = "shared/asphalt_01.lua",
		[2] = "shared/asphalt_02.lua",
		[3] = "shared/asphalt_03.lua",
		[4] = "shared/gravel_03.lua",
		[5] = "shared/gravel_04.lua",
		[6] = "shared/water_dirty.lua",
	}
}
end
