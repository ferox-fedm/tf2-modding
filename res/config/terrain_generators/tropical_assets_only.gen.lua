local maputil = require "maputil"
local mathutil = require "mathutil"
local tropicalassetsgen = require "terrain/tropicalassetsgen"
local layersutil = require "terrain/layersutil"

function data() 

return {
	climate = "tropical.clima.lua",
	order = 2,
	editorOnly = true,
	name = _("Tropical (assets only)"),
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
		-- local tropicalassetsgen = dofile("./res/scripts/terrain/tropicalassetsgen.lua")
		
		local result = { }
		
		params.forest = params.forest / 6
		
		local humidity = params.forest / 2 -- reduce number of trees

		result.parallelFactor = 32
		
		result.heightmapLayer = "HM"
		local distanceMap = "DM"
		
		local mkTemp = layersutil.TempMaker.new()
		
		result.layers = layersutil.Layer.new()
		
		result.layers:Distance(result.heightmapLayer, distanceMap)
		local hmCopyMap = mkTemp:Get()
		result.layers:Copy(result.heightmapLayer, hmCopyMap)
		
		local config = {
			noWater = humidity == 0,
			humidity = humidity,
		}
		
		result.forestMap, result.treesMapping, result.assetsMap, result.assetsMapping = tropicalassetsgen.Make(
			result.layers, config, mkTemp, result.heightmapLayer, hmCopyMap, distanceMap
		)
		
		hmCopyMap = mkTemp:Restore(hmCopyMap)

		mkTemp:Restore(result.forestMap)
		mkTemp:Restore(result.assetsMap)
		mkTemp:Finish()
		-- maputil.PrintGraph(result)

		return result
	end
}

end
