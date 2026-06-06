local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/saw_mill_2.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 128, 160 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_brown.lua",
		[3] = "gravel_01.lua",
		[4] = "shared/asphalt_02.lua",
		[5] = "shared/asphalt_03.lua",
		[6] = "shared/gravel_04.lua",
	},

	priority = 20,
}
end
