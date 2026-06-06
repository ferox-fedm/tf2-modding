local tu = require "texutil"

function data()
return {
	indices = {
		data = "0",
		size = { 1, 1 },
	},
	texSize = { 172, 132 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_brown.lua",
		[3] = "grass_dark_green.lua",
		[4] = "grass_green.lua",
		[5] = "grass_light_green.lua",
		[6] = "shared/corn.lua",
		[7] = "shared/grass_cutted_02.lua",
		[8] = "shared/gravel_04.lua",
		[9] = "shared/wheat.lua",
	},
	priority = 20,
}
end
