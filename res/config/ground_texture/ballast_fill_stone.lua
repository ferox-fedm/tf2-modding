local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 8.0, 1.0 },
	materialIndexMap = {
		[255] = "shared/ballast.lua",
	},
	
	priority = 10
}
end
