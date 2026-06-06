local maputil = require "maputil"
local temperateassetsgen = require "terrain/temperateassetsgen"
local layersutil = require "terrain/layersutil"

function data() 

return {
	climate = "temperate.clima.lua",
	order = 0,
	editorOnly = true,
	name = _("Temperate (assets only)"),
	params = {
		{
			key = "forest",
			name = _("Forest"),
			values = { _("Very low"), _("Low"), _("Medium"), _("High"), _("Very high"), _("Maximal"), },
			defaultIndex = 2,
			uiType = "SLIDER",
		},
		{
			key = "forestH",
			name = _("Hills forest height"),
			values = { _("Very low"), _("Low"), _("Medium"), _("High"), _("Very high"), _("Maximal"), },
			defaultIndex = 0,
			uiType = "SLIDER",
		},
		{
			key = "treeLimit",
			name = _("Tree limit"),
			values = { _("Very low"), _("Low"), _("Medium"), _("High"), _("Very high"), _("Maximal"), },
			defaultIndex = 3,
			uiType = "SLIDER",
		},
	},
	updateFn = function(params)
		-- local temperateassetsgen = dofile("./res/scripts/terrain/temperateassetsgen.lua")
		
		local result = { }
		
		local humidity = params.forest / 6

		result.parallelFactor = 32
		
		local config =  {
			humidity = humidity / 2.5,
			water = params.water,
			-- LEVEL 3
			hillsLowLimit = 20 + 10 * (params.forestH + 1), -- relative [m]
			hillsLowTransition = 20, -- relative [m]
			-- LEVEL 4
			treeLimit = 100 + 50 * params.treeLimit, -- absolute [m] (absolute maximal height)
			ridgeFactor = 0.1, -- lower means softer ridges detection, more trees (0.8)
			valleyFactor = 0.1, -- lower means softer valleys detection, more trees (0.8)
		}
		
		local mkTemp = layersutil.TempMaker.new()
		
		result.layers = layersutil.Layer.new()
		
		result.heightmapLayer = "HM"
		
		local distanceMap = mkTemp:Get()
		local ridgesMap = mkTemp:Get()
		
		result.layers:Distance(result.heightmapLayer, distanceMap)
		result.layers:Copy(result.heightmapLayer, ridgesMap)
		
		result.forestMap, result.treesMapping, result.assetsMap, result.assetsMapping = temperateassetsgen.Make(
			result.layers, config, mkTemp, result.heightmapLayer, ridgesMap, distanceMap
		)
		distanceMap = nil
		
		mkTemp:Restore(ridgesMap)
		mkTemp:Restore(result.forestMap)
		mkTemp:Restore(result.assetsMap)
		mkTemp:Finish()
		-- maputil.PrintGraph(result)
	
		return result
	end
}

end
