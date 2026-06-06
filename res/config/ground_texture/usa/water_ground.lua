local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/mat255.tga", true, false,false),
	materialIndexMap = {
		--[255] = "18_river_bed.lua",
	},
	
	priority = 6
}
end
