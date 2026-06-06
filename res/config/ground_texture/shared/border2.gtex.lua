local tu = require "texutil"

function data()
return {
	indices = {
		data = "0",
		size = { 1, 1 },
	},
	texSize = { 1.0, 1.0 },
	materialIndexMap = {
		[0] = "dirt.lua",
	},
	
	priority = 110000000
}
end
