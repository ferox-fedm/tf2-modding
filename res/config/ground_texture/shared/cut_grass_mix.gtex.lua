local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/cut_grass_mix.tga", "REPEAT", "REPEAT"),
	texSize = { 512, 512 },
	materialIndexMap = {
		[0] = "shared/grass_cutted_01.lua",
		[1] = "shared/grass_cutted_02.lua",
	},
	
	priority = 10
}
end
