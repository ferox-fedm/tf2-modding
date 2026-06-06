local maputil = require "maputil"
local vec2 = require "vec2"
local layersutil = require "terrain/layersutil"
local tu = require "texutil"

function data() 

return {
	id = "tropical",
	name = _("Tropical"),
	desc = _("Tropical vegetation"),
	mapColoring = {
		-- texture = {
			-- levels = { -100.0, 130.0, 260.0, 370.0, 450.0, 500.0 },
			-- fileName = "terrain/level_colors.tga",
		-- },
		levels = {
			{ color = maputil.MakeColor{232, 209, 142}, height = 0.0 },
			{ color = maputil.MakeColor{93, 112, 66}, height = 1.0 },
			{ color = maputil.MakeColor{64, 78, 50}, height = 100.0 },
			{ color = maputil.MakeColor{242, 235, 220}, height = 550.0 },
		},
		waterColor0 = maputil.MakeColor{60, 201, 214},
		waterColor1 = maputil.MakeColor{5, 56, 89},
		ambientColor = maputil.MakeColor{ 255, 238, 205 },
		sunColor = maputil.MakeColor{ 247, 228, 213 },
	},
	groundTextures = {
		waterGround = "water_ground.lua",
		waterShore = "water_shore.lua",
		farmland = "farmland.lua",
		farmlandBorder = "farmland_border.lua"
	},
	skirt = {
		colorTex = tu.makeTextureMipmapClampVertical("terrain/skirt_color.dds", false),
		detailTex = tu.makeTextureMipmapRepeat("terrain/skirt_detail.dds", false),
		waterTex = tu.makeTextureMipmapClamp("terrain/water_skirt.dds", false)
	},
	vehicleSet = "tropical",
	order = 3,
	updateFn = function(params)
		local result = { 
			layers = layersutil.Layer.new(),
		}
		local heightmap = "heightmap"
		local mkTemp = layersutil.TempMaker.new()
		-- mkTemp.doDebug = true
		
		-- #################
		-- #### CONFIG
		-- Greener grass
		local layer2_BaseRiverDistanceMin = 10
		local layer2_BaseRiverDistanceMax = 200 -- max: 256
		local layer2_NoiseStrength = 1.4
		local layer2_AmbientLevelsFrom = { 100, 200 } -- 0 to 255
		local layer2_AmbientLevelsTo = { 0.6, 1.0}
		-- Dark grass
		-- Brown grass
		local layer4_AmbientLevelsFrom = { 180, 248 } -- 0 to 255
		local layer4_AmbientLevelsTo = { 0.9, 0} 
		-- Stone cliffs
		
		-- Gravel beach
		local layerBeach_maxDistance = 80
		local layerBeach_gravelToStoneRatio = 0.4
		local layerBeach_gain = 0.9
		
		-- #################
		-- #### PREPARE
		local distanceMap = mkTemp:Get()
		result.layers:Distance(heightmap, distanceMap, params.waterLevel)
		local ambientMap = mkTemp:Get()
		result.layers:AmbientOcclusion(heightmap, ambientMap, 14)
		
		-- #################
		-- #### LEVEL 2 - greener grass
		local noiseMap = mkTemp:Get()
		result.layers:PerlinNoise(noiseMap, {})
		
		local layer2Map = mkTemp:Get()
		result.layers:Map(distanceMap, layer2Map, { layer2_BaseRiverDistanceMin, layer2_BaseRiverDistanceMax }, { -1, 0}, true)
		
		result.layers:Map(noiseMap, noiseMap, {-1, 1}, {0, layer2_NoiseStrength}, true)
		
		local temp1Map = mkTemp:Get()
		result.layers:Map(ambientMap, temp1Map, layer2_AmbientLevelsFrom, layer2_AmbientLevelsTo, true)
		
		local layer3Map = mkTemp:Get()
		result.layers:Mul(temp1Map, noiseMap, layer3Map)
		
		result.layers:Add(layer2Map, layer3Map, layer2Map)
		
		-- #################
		-- #### LEVEL 3 - dark grass
		local temp2Map = mkTemp:Get()
		result.layers:Pwlerp(heightmap, temp2Map,
			{ 0, 30, 60, 90, 120 },
			{ 0, 0, 0.6, 0, 0}
		)
		result.layers:Mul(temp2Map, temp1Map, temp1Map)
		temp2Map = mkTemp:Restore(temp2Map)
		
		result.layers:Mul(temp1Map, noiseMap, layer3Map)
		noiseMap = mkTemp:Restore(noiseMap)
		temp1Map = mkTemp:Restore(temp1Map)
		
		-- #################
		-- #### LEVEL 4 - brown grass
		local layer4Map = mkTemp:Get()
		result.layers:Map(ambientMap, layer4Map, layer4_AmbientLevelsFrom, layer4_AmbientLevelsTo, false)
		ambientMap = mkTemp:Restore(ambientMap)
		
		do
			local temp1Map = mkTemp:Get()
			result.layers:Pwlerp(heightmap, temp1Map,
				{ -10, -5, 5, 50, 150 },
				{ 0, 0, 1, 0, 0}
			)
			result.layers:Mul(layer4Map, temp1Map, layer4Map)
			temp1Map = mkTemp:Restore(temp1Map)
		end
		
		-- Optional step
		result.layers:Pwlerp(layer4Map, layer4Map,
			{0, 0.1, 0.3, 1.0},
			{0, 0, 1.0, 1.0}
		)
		
		-- Cutoff river
		do
			local temp1Map = mkTemp:Get()
			result.layers:Map(distanceMap, temp1Map, { 150, 250 }, { 0, 1}, true)
			
			result.layers:Mul(layer4Map, temp1Map, layer4Map)
			temp1Map = mkTemp:Restore(temp1Map)
		end
		
		-- #################
		-- #### LEVEL 2: cliff
		local level2_CliffCutoff = { 0.8, 0.9 }
		
		local layer5Map
		local beachMaskMap
		do
			local temp1Map = mkTemp:Get()
			result.layers:Grad(heightmap, temp1Map, 2)
			
			local temp2Map = mkTemp:Get()
			result.layers:Pwlerp(distanceMap, temp2Map,
				{-10, 0, 70, 80, 90},
				{2, 2, 1, 0, 0.0}
			)
			
			result.layers:Mul(temp1Map, temp2Map, temp2Map)
			
			result.layers:Map(temp2Map, temp2Map, { 0.5, 0.4}, { -1, 1}, true)
			
			local temp3Map = mkTemp:Get()
			result.layers:Pwconst(heightmap, temp3Map, {0}, {2, 0})
			
			result.layers:Add(temp2Map, temp3Map, temp2Map)
			temp3Map = mkTemp:Restore(temp3Map)
			
			result.layers:Distance(temp2Map, temp2Map)
			
			beachMaskMap = mkTemp:Get()
			result.layers:Map(temp2Map, beachMaskMap, { 6, 103}, {0, 1}, true)
			
			result.layers:Map(temp2Map, temp2Map, { 6, 12}, {1, 0}, true)
			
			result.layers:Map(temp1Map, temp1Map, level2_CliffCutoff, {0, 1}, true)
			
			layer5Map = mkTemp:Get()
			result.layers:Add(temp2Map, temp1Map, layer5Map)
			temp1Map = mkTemp:Restore(temp1Map)
			temp2Map = mkTemp:Restore(temp2Map)
		end
		
		local layer5bMap = mkTemp:Get()
		result.layers:Map(layer5Map, layer5bMap, { 0.0, 1.0}, { 0.0, 0.5}, true)
		
		-- #################
		-- #### BEACH LAYER - sand and wet sand
		local layer6Map = mkTemp:Get()
		result.layers:Map(distanceMap, layer6Map, { 0, layerBeach_maxDistance }, { 2.3, 0}, true)
		distanceMap = mkTemp:Restore(distanceMap)
		
		do
			local noiseMap = mkTemp:Get()
			result.layers:RidgedNoise(noiseMap, {octaves = 3, lacunarity = 10.5, frequency = 1.0 / 1000.0, gain = layerBeach_gain})
			
			result.layers:Map(noiseMap, noiseMap, { 0.2, 0.8 }, { -1.3, 0}, true)
			
			result.layers:Mul(layer6Map, beachMaskMap, layer6Map)
			beachMaskMap = mkTemp:Restore(beachMaskMap)

			result.layers:Add(layer6Map, noiseMap, layer6Map)
			noiseMap = mkTemp:Restore(noiseMap)
		end
		
		local layer7Map = mkTemp:Get()
		result.layers:Map(layer6Map, layer7Map, { 0.0, 1.0 }, { 0.0, layerBeach_gravelToStoneRatio}, true)
		
		-- Add
		local layerWetSandAMap = mkTemp:Get()
		result.layers:Pwconst(heightmap, layerWetSandAMap, { 0.0 }, { 1.0, 0.0})
		
		local layerWetSandBMap = mkTemp:Get()
		result.layers:Pwconst(heightmap, layerWetSandBMap, { -0.1 }, { 1.0, 0.0})
		
		-- #################
		-- #### MIX
		result.mixingLayer = {
			backgroundMaterial = "tropical/grass_light_green.lua",
			layers = {
				-- Grass
				{
					map = layer2Map,
					dither = true,
					material = "tropical/grass_green.lua",
				},
				{
					map = layer4Map,
					dither = true,
					material = "tropical/grass_brown.lua",
				},
				{
					map = layer3Map,
					dither = true,
					material = "tropical/grass_dark_green.lua",
				},
				
				-- Beach
				{
					map = layer6Map,
					dither = true,
					material = "tropical/sand_03.lua",
				},
				{
					map = layer7Map,
					dither = true,
					material = "tropical/sand_02.lua",
				},
				{
					map = layerWetSandAMap,
					dither = true,
					material = "tropical/sand_01.lua",
				},
				{
					map = layerWetSandBMap,
					dither = true,
					material = "tropical/sand_04.lua",
				},
				
				-- Cliff and slopes (wins over sand)
				{
					map = layer5Map,
					dither = true,
					material = "tropical/rock.lua",
				},
				{
					map = layer5bMap,
					dither = true,
					material = "tropical/scree.lua",
				},
				
			}
		}
		
		mkTemp:RestoreAll(result.mixingLayer)
		mkTemp:Finish()
		
		-- maputil.PrintGraph(result)
		
		return result
	end
}

end