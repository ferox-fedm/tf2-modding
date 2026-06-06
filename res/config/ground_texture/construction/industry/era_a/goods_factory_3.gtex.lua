local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/goods_factory_3.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
		
	texSize = { 126, 154 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_gravel.lua",
		[3] = "gravel_01.lua",
		[4] = "shared/asphalt_01.lua",
		[5] = "shared/asphalt_02.lua",
		[6] = "shared/asphalt_03.lua",
		[7] = "shared/gravel_03.lua",
		[8] = "shared/water_dirty.lua",
	}

}
end
