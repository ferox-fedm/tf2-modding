local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/path.tga", "REPEAT", "REPEAT"),
	texSize = { 512, 6 },
	materialIndexMap = {
		[50] = "grass_brown.lua",
		[100] = "dirt.lua",
		[150] = "shared/gravel_04.lua",
	},
	
	priority = 12
}
end
