local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 1.0, 1.0 },
	
	priority = 100,
	materialIndexMap = {
		[255] = "shared/asphalt_01.lua",
	},
}
end
