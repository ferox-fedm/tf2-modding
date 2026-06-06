local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 4.0, 1.0 },

	priority = 1,
	materialIndexMap = {
		[255] = "dirt.lua",
	},
}
end
