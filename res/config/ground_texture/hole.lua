local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	texSize = { 32.0, 32.0 },
	materialIndexMap = {
		[255] = "",
	},
	priority = 5000
}
end
