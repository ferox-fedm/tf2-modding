local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/quarry_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
	
	texSize = { 144, 149 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_brown.lua",
		[3] = "grass_gravel.lua",
		[4] = "gravel_01.lua",
		[5] = "rock.lua",
		[6] = "scree.lua",
		[7] = "shared/gravel_03.lua",
	}
}
end
