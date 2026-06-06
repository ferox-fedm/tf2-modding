local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 2.0, 2.0 },
	materialIndexMap = {
		[255] = "grass_brown.lua",
	},
}
end
