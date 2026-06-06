local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 8.0, 8.0 },
	
	priority = 10,
	materialIndexMap = {
		[255] = "shared/asphalt_02.lua",
	},
}
end
