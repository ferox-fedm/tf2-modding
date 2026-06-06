local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false, false),
	texSize = { 2.0, 2.0 },
	materialIndexMap = {
	},

	priority = 8
}
end
