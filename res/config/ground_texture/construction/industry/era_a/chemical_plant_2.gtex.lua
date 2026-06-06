local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/chemical_plant_2.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 156, 156 },
	materialIndexMap = {	
		[1] = "dirt.lua",
		[2] = "shared/asphalt_01.lua",
		[3] = "shared/asphalt_02.lua",
		[4] = "shared/asphalt_03.lua",
		[5] = "shared/water_dirty.lua",
	},
	priority = 20,
}
end
