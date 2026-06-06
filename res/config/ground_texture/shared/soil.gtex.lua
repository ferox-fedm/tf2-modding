local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/mix.tga", "REPEAT", "REPEAT"),
	texSize = { 512, 512 },
	materialIndexMap = {
		[0] = "shared/soil_01.lua",
		[100] = "dirt.lua",
	},
	
	priority = 1
}
end
