local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/border.tga", "REPEAT", "REPEAT"),
	texSize = { 256.0, 3.0 },
	materialIndexMap = {
		[50] = "grass_brown.lua",
		[100] = "dirt.lua",
		[150] = "shared/gravel_03.lua",
	},
	
	priority = 11
}
end
