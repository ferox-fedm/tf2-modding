local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/usa_tree_ground.tga", true, false,false),
	texSize = { 16.0, 16.0 },
	materialIndexMap = {
		[170] = "usa/forest_ground.lua",
		[255] = "usa/dirt.lua",
	},
	
	priority = 1
}
end
