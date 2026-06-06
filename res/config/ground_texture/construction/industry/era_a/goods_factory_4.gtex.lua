local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/goods_factory_4.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
		
	texSize = { 126, 154 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_gravel.lua",
		[3] = "shared/asphalt_01.lua",
		[4] = "shared/asphalt_02.lua",
		[5] = "shared/gravel_03.lua",
		[6] = "shared/water_dirty.lua",
	}
}
end
