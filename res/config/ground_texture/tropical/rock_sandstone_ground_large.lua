local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 9.0, 9.0 },
	materialIndexMap = {
		[255] = "tropical/gravel_01.lua",
	},
}
end
