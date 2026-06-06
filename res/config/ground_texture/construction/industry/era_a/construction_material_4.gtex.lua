local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/construction_material_4.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
	
	texSize = { 148, 110 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "gravel_01.lua",
		[3] = "scree.lua",
		[4] = "shared/asphalt_02.lua",
		[5] = "shared/asphalt_03.lua",
		[6] = "shared/gravel_03.lua",
	}
}
end
