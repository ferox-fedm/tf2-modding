local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/construction_material_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
	
	texSize = { 148, 110 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_brown.lua",
		[3] = "grass_dark_green.lua",
		[4] = "grass_gravel.lua",
		[5] = "gravel_01.lua",
		[6] = "scree.lua",
		[7] = "shared/asphalt_02.lua",
		[8] = "shared/asphalt_03.lua",
		[9] = "shared/gravel_03.lua",
		[10] = "shared/water_dirty.lua",
	}
}
end
