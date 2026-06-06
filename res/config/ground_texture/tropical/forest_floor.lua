local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/forest_ground.tga", true, false,false),
	texSize = { 32.0, 32.0 },
	materialIndexMap = {
		[255] = "tropical/forest_ground.lua",
	},

}
end
