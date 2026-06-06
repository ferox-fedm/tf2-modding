local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	
	priority = 10,
	materialIndexMap = {
		[255] = "shared/asphalt_02.lua",
	},
}
end
