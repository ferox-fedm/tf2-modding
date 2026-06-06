local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/tree_ground.tga", true, false,false),
	texSize = { 8.0, 8.0 },
	materialIndexMap = {
		[128] = "tropical/dirt.lua",
		[255] = "tropical/forest_ground.lua",
	},

	priority = 3
}
end
