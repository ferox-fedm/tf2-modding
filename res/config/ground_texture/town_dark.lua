local tu = require "texutil"

function data()
return {
	texture = tu.makeTextureLinearNearest("res/textures/terrain/material/town_dark.tga", true, false,false),
	texSize = { 96.0, 96.0 },
	materialIndexMap = {
		--[108] = "01_green_grass.lua",
		--[255] = "10_stone_4.lua",
		--[123] = "10_stone_4.lua",
	},
}
end
