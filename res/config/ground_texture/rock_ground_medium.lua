local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 8.0, 8.0 },
	materialIndexMap = {
		[255] = "scree.lua",
	},
}
end
