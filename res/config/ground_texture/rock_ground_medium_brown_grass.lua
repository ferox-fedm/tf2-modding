local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/rock_ground.tga", true, false,false),
	texSize = { 5.0, 5.0 },
	materialIndexMap = {
		[255] = "grass_brown.lua",
	},
}
end
