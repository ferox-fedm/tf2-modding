local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 5, 5 },
	materialIndexMap = {
		[255] = "tropical/scree.lua",
	},
}
end
