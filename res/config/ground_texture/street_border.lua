local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/street_border.tga", "REPEAT", "REPEAT"),
	texSize = { 32.0, 1.5 },
	materialIndexMap = {
		[160] = "dirt.lua",
		[255] = "shared/gravel_03.lua",
	},
	
	priority = 16
}
end
