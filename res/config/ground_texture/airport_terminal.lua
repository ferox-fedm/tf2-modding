local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/station/air/airport/era_b_airport_terminal.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
	texSize = { 60, 155 },
	materialIndexMap = {
		[0] = "shared/asphalt_01.lua",
		[1] = "shared/asphalt_05.lua",
		[2] = "shared/grass_cutted_01.lua",
		[3] = "usa/dirt.lua",
	},
	priority = 14,
}
end
