local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/forest_ground.tga", true, false,false),
	texSize = { 22.0, 22.0 },
	materialIndexMap = {
		[255] = "forest_ground.lua",
	},
	
	priority = 1
}
end
