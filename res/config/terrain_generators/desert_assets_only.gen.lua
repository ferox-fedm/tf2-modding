local maputil = require "maputil"
local desertassetsgen = require "terrain/desertassetsgen"
local layersutil = require "terrain/layersutil"
local vec2 = require "vec2"
require "math"

function data() 
return {	
	climate = "dry.clima.lua",
	order = 1,
	editorOnly = true,
	name = _("Desert (assets only)"),
	params = {
		{
			key = "forest",
			name = _("Forest"),
			values = { _("Very low"), _("Low"), _("Medium"), _("High"), _("Very high"), _("Maximal"), },
			defaultIndex = 2,
			uiType = "SLIDER",
		},
	},
	updateFn = function(params)
		-- local desertassetsgen = dofile("./res/scripts/terrain/desertassetsgen.lua")
		-- local layersutil = dofile("./res/scripts/terrain/layersutil.lua")
		local result = { }

		params.forest = params.forest / 6
		
		local humidity = params.forest

		result.parallelFactor = 32
		
		result.heightmapLayer = "HM"
		
		local ridgesMap = "RM"
		local mesaMap = "MM"
		local distanceMap = "DM"

		result.layers = layersutil.Layer.new()
	
		local config = {
			noWater = humidity <= 0,
			humidity = humidity,
		}
		
		local mkTemp = layersutil.TempMaker.new()
		result.layers:Distance(result.heightmapLayer, distanceMap)
		result.layers:Copy(result.heightmapLayer, ridgesMap)
		result.layers:Copy(result.heightmapLayer, mesaMap)
		
		local canyonCutoffMap = mkTemp:Get()
		result.forestMap, result.treesMapping, result.assetsMap, result.assetsMapping = desertassetsgen.Make(
			result.layers, mkTemp, config, result.heightmapLayer, ridgesMap, mesaMap, ridgesMap, canyonCutoffMap, distanceMap
		)
		canyonCutoffMap = mkTemp:Restore(canyonCutoffMap)
		
		mkTemp:Restore(result.forestMap)
		mkTemp:Restore(result.assetsMap)
		mkTemp:Finish()
		-- maputil.PrintGraph(result)
		
		return result
	end
}

end