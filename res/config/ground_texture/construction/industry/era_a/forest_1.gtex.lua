local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/forest_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
	texSize = { 180, 180 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "forest_ground.lua",
		[3] = "grass_alpine.lua",
		[4] = "grass_brown.lua",
		[5] = "gravel_01.lua",
		[6] = "scree.lua",
	},
	priority = 20,
}
end
