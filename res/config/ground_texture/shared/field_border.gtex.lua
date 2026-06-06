local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/border.tga", "REPEAT", "REPEAT"),
	texSize = { 256.0, 7.0 },
	materialIndexMap = {
		[50] = "dirt.lua",
		[100] = "dirt.lua",
		[150] = "grass_brown.lua",
	},
	
	priority = 2
}
end
