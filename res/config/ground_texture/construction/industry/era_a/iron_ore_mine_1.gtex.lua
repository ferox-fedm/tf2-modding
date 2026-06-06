local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/iron_ore_mine_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 160, 180 },
	materialIndexMap = {
			[1] = "dirt.lua",
		[2] = "grass_gravel.lua",
		[3] = "gravel_01.lua",
		[4] = "shared/asphalt_02.lua",
		[5] = "shared/asphalt_03.lua",
		[6] = "shared/grass_cutted_02.lua",
		[7] = "shared/gravel_03.lua",
		[8] = "shared/gravel_04.lua",
		[9] = "shared/soil_01.lua",
		[10] = "shared/water_dirty.lua",
	},
	priority = 20,
}
end
