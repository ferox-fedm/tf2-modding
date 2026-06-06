local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/fuel_refinery_4.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 173.795, 146.977 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "shared/grass_cutted_01.lua",
		[3] = "shared/asphalt_01.lua",
		[4] = "shared/asphalt_02.lua",
		[5] = "shared/asphalt_03.lua",
		[6] = "shared/grass_cutted_02.lua",
		[7] = "shared/gravel_04.lua",
	},
	priority = 20,
}
end
