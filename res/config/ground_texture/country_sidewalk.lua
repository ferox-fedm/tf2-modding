local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/country_sidewalk.tga", "REPEAT", "REPEAT"),
	texSize = { 64.0, 3.0 },
	materialIndexMap = {
		[160] = "dirt.lua",
		[255] = "shared/gravel_03.lua",
	},
	
	priority = 6
}
end
