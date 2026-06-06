local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 8.0, 2.0 },
	materialIndexMap = {
		[255] = "dirt.lua",
	},
	
	priority = 10
}
end
