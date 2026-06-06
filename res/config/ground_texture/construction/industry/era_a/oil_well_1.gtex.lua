local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/oil_well_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
	
	texSize = { 138, 152 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "gravel_01.lua",
		[3] = "shared/asphalt_03.lua",
		[4] = "shared/gravel_02.lua",
		[5] = "shared/gravel_03.lua",
		[6] = "shared/water_dirty.lua",
	},
	priority = 20,

}
end
