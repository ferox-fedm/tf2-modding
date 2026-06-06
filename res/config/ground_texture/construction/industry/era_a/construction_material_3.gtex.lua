local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/construction_material_3.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
		
	texSize = { 148, 110 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "scree.lua",
		[3] = "shared/asphalt_02.lua",
		[4] = "shared/asphalt_03.lua",
		[5] = "shared/gravel_03.lua",
		[6] = "shared/water_dirty.lua",
	}

}
end
