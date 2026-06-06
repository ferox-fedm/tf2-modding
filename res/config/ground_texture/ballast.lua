local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/ballast.tga", "REPEAT", "REPEAT"),
	texSize = { 32.0, 4.0 },
	materialIndexMap = {
		[160] = "dirt.lua",
		[255] = "shared/ballast.lua",
	},
	
	priority = 12
}
end
