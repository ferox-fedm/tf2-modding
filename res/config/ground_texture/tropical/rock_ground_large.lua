local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 16.0, 16.0 },
	materialIndexMap = {
		[255] = "tropical/scree.lua",
	},
}
end
