local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/fuel_refinery_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 173.795, 146.977 },
	materialIndexMap = {
		[1] = "shared/asphalt_01.lua",
		[2] = "shared/asphalt_02.lua",
		[3] = "shared/asphalt_03.lua",
		[4] = "shared/gravel_03.lua",
	},
	priority = 20,
}
end
