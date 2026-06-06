local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 64.0, 64.0 },
	materialIndexMap = {
		[255] = "shared/asphalt_02.lua",
	},
	priority = 12000,
}
end
