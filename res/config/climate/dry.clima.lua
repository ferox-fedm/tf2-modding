local maputil = require "maputil"
local vec2 = require "vec2"
local layersutil = require "terrain/layersutil"
local tu = require "texutil"

function data() 

return {
	id = "dry",
	name = _("Dry"),
	desc = _("Shrubland vegetation"),
	mapColoring = {
		-- texture = {
			-- levels = { -100.0, 130.0, 260.0, 370.0, 450.0, 500.0 },
			-- fileName = "terrain/usa/level_colors.tga",
		-- },
		levels = {
			{ color = maputil.MakeColor{165, 129, 85}, height = 0.0 },
			{ color = maputil.MakeColor{175, 153, 105}, height = 150.0 },
			{ color = maputil.MakeColor{124, 121, 85}, height = 250.0 },
			{ color = maputil.MakeColor{125, 126, 98}, height = 350.0 },
			{ color = maputil.MakeColor{242, 235, 220}, height = 550.0 },
		},
		ambientColor = maputil.MakeColor{ 205, 219, 255 },
		sunColor = maputil.MakeColor{ 255, 245, 240 },
	},
	groundTextures = {
		waterGround = "usa/water_ground.lua",
		waterShore = "water_shore.lua",
		farmland = "usa/farmland.lua",
		farmlandBorder = "usa/farmland_border.lua"
	},
	skirt = {
		colorTex = tu.makeTextureMipmapClampVertical("terrain/skirt_color.dds", false),
		detailTex = tu.makeTextureMipmapRepeat("terrain/skirt_detail.dds", false),
		waterTex = tu.makeTextureMipmapClamp("terrain/water_skirt.dds", false)
	},
	vehicleSet = "usa",
	order = 2,
	updateFn = function(params)
		local result = { 
			layers = layersutil.Layer.new()
		}
		local heightmap = "heightmap"
		local mkTemp = layersutil.TempMaker.new()
		-- mkTemp.doDebug = true
		
		-- #################
		-- #### CONFIG
		-- Sand river bank
		local layer_0_RiverBankNoiseStrength = -0.9 -- lower = stronger noise
		local layer_0_RiverBankMaxDistance = 50 -- meters
		local layer_0_RiverBankGain = 0.9 
		-- Layer heights configs
		local layer_2_Start = 70 -- Layer 2: Slopes
		local layer_2_End = 90
		local layer_3_Start = 80 -- Layer 3: Mesa top and canyon top
		local layer_3_End =  110
		local layer_4_Start = 130 -- Layer 4 (grass gravel)
		local layer_4_End =  220
		local layer_5_Start = 220 -- Layer 5 (flat rocks)
		local layer_5_End =  280
		
		-- Slopes threshold configs
		local mesaSlopeStart = 0.4
		local mesaSlopeEnd = 0.6
		
		local rockSlopeStart = 0.6
		local rockSlopeEnd = 0.8
		
		local mesaBStrength = 0.7 -- 0 = cliff_canyon_04, 1 = cliff_canyon_02
		local rockBStrength = 0.4 -- 0 = rock, 1 = scree
		local mesa2RockTransitionStart = layer_4_Start
		local mesa2RockTransitionEnd = layer_4_End
		
		local riverMaterialDistance = 250
		
		local layer_1_grassAmount = 0.5
		
		local ambientStrength = 1
		
		-- #################
		-- #### DETECT EDGES
		local layer_special_edge_FinalMap = mkTemp:Get()
		result.layers:Laplace(heightmap, layer_special_edge_FinalMap)
		result.layers:Map(layer_special_edge_FinalMap, layer_special_edge_FinalMap, { -0.4, -0.1 }, { 1.0, 0.0}, true)
		
		-- #################
		-- #### PREPARE
		local distanceMap = mkTemp:Get()
		result.layers:Distance(heightmap, distanceMap, params.waterLevel)
		local ambientMap = mkTemp:Get()
		result.layers:AmbientOcclusion(heightmap, ambientMap, 50)
		
		-- Ab noise for flat and river
		local noiseMap = mkTemp:Get()
		local noiseMap2 = mkTemp:Get()
		result.layers:RidgedNoise(noiseMap, { octaves = 4, frequency = 1.0 / 1200.0, lacunarity = 4.5, gain = 0.9})
		result.layers:Copy(noiseMap, noiseMap2)
		
		-- #################
		-- #### Layer 1: savannah, yellow sand with grass
		local layer_1_2a_FinalMap = mkTemp:Get()
		result.layers:Map(noiseMap, layer_1_2a_FinalMap, {0.8, 0.3}, {0.0, 1.0}, true)
		-- #################
		-- #### Layer 1: desert, red sand under trees
		local layer_1_1b_FinalMap = mkTemp:Get()
		result.layers:Map(noiseMap, layer_1_1b_FinalMap, {0.2, 1.0}, {0.0, 1.0}, true)
		
		-- #################
		-- #### Layer 0: River cutoff bank A
		local layer_0a_FinalMap = mkTemp:Get()
		do
			local tempMap = mkTemp:Get()
			result.layers:Map(noiseMap, tempMap, {0.0, 1.0}, {0, 50}, true)
			
			result.layers:Add(distanceMap, tempMap, tempMap)
			
			result.layers:Map(tempMap, layer_0a_FinalMap,
				{ 40, riverMaterialDistance },
				{ 1, 0}, true
			)
			tempMap = mkTemp:Restore(tempMap)
		end
		
		-- #################
		-- #### LAYER 0: River bank B
		local layer_0b_FinalMap = mkTemp:Get()
		do
			result.layers:Map(distanceMap, layer_0b_FinalMap, { 0, layer_0_RiverBankMaxDistance }, { 2.3, 0}, true)
			
			local tempMap = mkTemp:Get()
			result.layers:Map(noiseMap, tempMap, { 0.2, 0.8 }, { layer_0_RiverBankNoiseStrength, 0}, true)
			result.layers:Add(layer_0b_FinalMap, tempMap, layer_0b_FinalMap)
			tempMap = mkTemp:Restore(tempMap)
		end
		
		-- #################
		-- #### CANYON MATERIAL
		local cutoffNoiseTempMap = mkTemp:Get()
		result.layers:CutoffNoise(cutoffNoiseTempMap, { frequency = 1 / 5, upperCutoff = -0.1, lowerCutoff = -0.2})
		
		result.layers:Map(cutoffNoiseTempMap, cutoffNoiseTempMap, { 0.0, 1.0 }, { 0, 1.0}, true)
		
		local slopeMap = mkTemp:Get()
		result.layers:Grad(heightmap, slopeMap, 3)
		
		local layer_slope_canyon_inner_a_FinalMap = mkTemp:Get()
		result.layers:Map(slopeMap, layer_slope_canyon_inner_a_FinalMap, { 0.9, 1.4 }, { 0, 1}, true)
		
		local layer_slope_canyon_outer_a_FinalMap = mkTemp:Get()
		do
			local tempMap = mkTemp:Get()
			result.layers:Map(distanceMap, tempMap, { 200, 210 }, { 1, 0}, true)
			result.layers:Mul(layer_slope_canyon_inner_a_FinalMap, tempMap, layer_slope_canyon_outer_a_FinalMap)
			tempMap = mkTemp:Restore(tempMap)
		end
			
		local canyonCutoffMap = mkTemp:Get()
		result.layers:Copy(layer_slope_canyon_inner_a_FinalMap, canyonCutoffMap)
		
		local layer_slope_canyon_outer_b_FinalMap = mkTemp:Get()
		result.layers:Mul(layer_slope_canyon_outer_a_FinalMap, cutoffNoiseTempMap, layer_slope_canyon_outer_b_FinalMap)
		
		-- Use distance instead of height to make slopes look nicer
		-- (technically should use height, or better canyon height)
		do
			local tempMap = mkTemp:Get()
			result.layers:Map(distanceMap, tempMap, { 75, 80 }, { 1, 0}, true)
			result.layers:Mul(layer_slope_canyon_inner_a_FinalMap, tempMap, layer_slope_canyon_inner_a_FinalMap)
			tempMap = mkTemp:Restore(tempMap)
		end
		
		local layer_slope_canyon_inner_b_FinalMap = mkTemp:Get()
		result.layers:Mul(layer_slope_canyon_inner_a_FinalMap, cutoffNoiseTempMap, layer_slope_canyon_inner_b_FinalMap)
		cutoffNoiseTempMap = mkTemp:Restore(cutoffNoiseTempMap)

		-- Height noise
		result.layers:Map(noiseMap, noiseMap, {0, 1}, { -20, 20})
		
		result.layers:Add(noiseMap, ambientMap, ambientMap)
		local hmNoisyCopyMap = mkTemp:Get()
		result.layers:Add(heightmap, noiseMap, hmNoisyCopyMap)
		
		-- Layer 5:
		local layer_5a_FinalMap = mkTemp:Get()
		result.layers:Map(hmNoisyCopyMap,  layer_5a_FinalMap, {layer_5_Start, layer_5_End}, {0, 1}, true)
		
		local layer_5b_FinalMap = mkTemp:Get()
		result.layers:Mul(layer_5a_FinalMap, layer_1_1b_FinalMap, layer_5b_FinalMap)
		
		-- Layer 4:
		local layer_4_FinalMap = mkTemp:Get()
		result.layers:Map(hmNoisyCopyMap, layer_4_FinalMap, {layer_4_Start, layer_4_End}, {0, 1}, true)
		
		-- Layer 2: Mesa bottom
		local layer_2a_FinalMap = mkTemp:Get()
		result.layers:Map(hmNoisyCopyMap, layer_2a_FinalMap, {layer_2_Start, layer_2_End}, {0, 1}, true)
		
		local layer_2b_FinalMap = mkTemp:Get()
		result.layers:Mul(layer_2a_FinalMap, layer_1_1b_FinalMap, layer_2b_FinalMap)
		
		-- Layer 3: mesa top Forest/Gravel
		local layer_3a_FinalMap = mkTemp:Get()
		result.layers:Map(hmNoisyCopyMap,  layer_3a_FinalMap, {layer_3_Start, layer_3_End}, {0, 1}, true)
		
		result.layers:Map(layer_1_1b_FinalMap, layer_1_1b_FinalMap, {0, 1}, {0.15, 1}, false) -- add more gree
		local layer_3b_FinalMap = mkTemp:Get()
		result.layers:Mul(layer_3a_FinalMap, layer_1_1b_FinalMap, layer_3b_FinalMap)
		
		-- Add extra noise from amb
		result.layers:Map(ambientMap, ambientMap, { 0, 255 }, { ambientStrength * 10 / 3, 0})
		result.layers:Add(ambientMap, layer_2b_FinalMap, layer_2b_FinalMap)
		
		-- Layer 2: Mesa bottom c
		local layer_2c_FinalMap = mkTemp:Get()
		result.layers:Map(layer_1_2a_FinalMap, layer_2c_FinalMap, { 1.0, 0.0 }, { 0, 1})
		result.layers:Map(ambientMap, ambientMap, { 0.0, 1.0 }, { 0, 3})
		result.layers:Mul(noiseMap, layer_2c_FinalMap, layer_2c_FinalMap)
		ambientMap = mkTemp:Restore(ambientMap)
		noiseMap = mkTemp:Restore(noiseMap)
		
		-- #################
		-- #### Cutoff canyon
		local layer_slope_mesa_a_FinalMap = mkTemp:Get()
		local layer_slope_mesa_b_FinalMap = mkTemp:Get()
		local layer_slope_rocky_a_FinalMap = mkTemp:Get()
		local layer_slope_rocky_b_FinalMap = mkTemp:Get()
		do
			local cutoffMap = mkTemp:Get()
			result.layers:Map(distanceMap, cutoffMap, {200, 230}, {0, 1}, true)
			
			result.layers:Mul(slopeMap, cutoffMap, slopeMap)
			result.layers:Map(slopeMap, layer_slope_mesa_a_FinalMap, {mesaSlopeStart, mesaSlopeEnd}, {0, 1}, true)
			result.layers:Map(slopeMap, layer_slope_rocky_a_FinalMap, {rockSlopeStart, rockSlopeEnd}, {0, 1}, true)
			slopeMap = mkTemp:Restore(slopeMap)
			
			do
				result.layers:Map(hmNoisyCopyMap, cutoffMap, {mesa2RockTransitionStart, mesa2RockTransitionEnd}, {1, 0}, true)
				result.layers:Mul(cutoffMap, layer_slope_mesa_a_FinalMap, layer_slope_mesa_a_FinalMap)
				result.layers:Map(layer_slope_mesa_a_FinalMap, layer_slope_mesa_b_FinalMap, {0,1},{0,mesaBStrength}, true)
				
				result.layers:Map(hmNoisyCopyMap, cutoffMap, {mesa2RockTransitionStart, mesa2RockTransitionEnd}, {0, 1}, true)
				result.layers:Mul(cutoffMap, layer_slope_rocky_a_FinalMap, layer_slope_rocky_a_FinalMap)
				result.layers:Map(layer_slope_rocky_a_FinalMap, layer_slope_rocky_b_FinalMap, {0,1},{0,rockBStrength}, true)
			end
			cutoffMap = mkTemp:Restore(cutoffMap)
			hmNoisyCopyMap = mkTemp:Restore(hmNoisyCopyMap)
		end
		
		-- Layer 1: Extra noise B material
		local layer_1_2b_FinalMap = mkTemp:Get()
		result.layers:Dithering(layer_1_2b_FinalMap, "LOCAL")
		result.layers:Mask(layer_1_2b_FinalMap, layer_1_2a_FinalMap, layer_1_2b_FinalMap, layer_1_grassAmount)
		
		-- #################
		-- #### CANYON COLORING
		-- Distance from water mask for when there is canyon
		do
			local tempMap = mkTemp:Get()
			result.layers:Pwconst(heightmap, tempMap, {30}, {0, 1})
			result.layers:Mul(canyonCutoffMap, tempMap, canyonCutoffMap)
			tempMap = mkTemp:Restore(tempMap)
		end
		
		result.layers:Map(canyonCutoffMap, canyonCutoffMap, {0, 1}, {1, -1}, true)
		result.layers:Distance(canyonCutoffMap, canyonCutoffMap)
		result.layers:Map(canyonCutoffMap, canyonCutoffMap, {0, 210}, {0.8, 0}, true)
		
		local layer_river_bed_FinalMap = distanceMap
		do
			local tempMap = mkTemp:Get()
			result.layers:Map(distanceMap, tempMap, {180, 220}, {1.4, 0}, true)
			
			result.layers:Pwconst(heightmap, distanceMap, {0}, {1, 0})

			-- Soft mask
			result.layers:Mul(canyonCutoffMap, tempMap, canyonCutoffMap)
			tempMap = mkTemp:Restore(tempMap)
		end
		
		local displacedHmMap = mkTemp:Get()
		--result.layers:RidgedNoise(noiseMap2, { octaves = 4, lacunarity = 2.9, frequency = 1.0 / 1045.0, gain = 3 * layer_0_RiverBankGain})
		
		result.layers:Map(noiseMap2, noiseMap2, {0, 1}, {0, 6}, false)
		result.layers:Add(heightmap, noiseMap2, displacedHmMap)
		
		local hmCopy2Map = mkTemp:Get()
		result.layers:Map(heightmap, hmCopy2Map, {21, 50}, {1, 0}, true) -- sand2
		local layer_canyon_gradient_5_FinalMap = mkTemp:Get()
		result.layers:Mul(canyonCutoffMap, hmCopy2Map, layer_canyon_gradient_5_FinalMap)
		result.layers:Map(displacedHmMap, hmCopy2Map, {11, 21}, {1, 0}, true) -- sand1
		local layer_canyon_gradient_4_FinalMap = mkTemp:Get()
		result.layers:Mul(canyonCutoffMap, hmCopy2Map, layer_canyon_gradient_4_FinalMap)
		result.layers:Map(displacedHmMap, hmCopy2Map, {5, 17}, {1, 0}, true) -- forest
		local layer_canyon_gradient_3_FinalMap = mkTemp:Get()
		result.layers:Mul(canyonCutoffMap, hmCopy2Map, layer_canyon_gradient_3_FinalMap)
		result.layers:Map(displacedHmMap, hmCopy2Map, {4, 5}, {1, 0}, true) -- sand
		local layer_canyon_gradient_1_FinalMap = mkTemp:Get()
		result.layers:Mul(canyonCutoffMap, hmCopy2Map, layer_canyon_gradient_1_FinalMap)
		local hmCopy3Map = mkTemp:Get()
		result.layers:Pwconst(displacedHmMap, hmCopy3Map, {3, 12}, {0, 1, 0}) -- grass
		
		result.layers:Map(noiseMap2, noiseMap2, {0, 1}, {-16, 16}, false)
		result.layers:Add(heightmap, noiseMap2, displacedHmMap)
		noiseMap2 = mkTemp:Restore(noiseMap2)
		
		result.layers:Pwlerp(displacedHmMap, hmCopy2Map, {0, 18, 80, 110}, {1, 1, 1.2, 0}) -- sand2
		displacedHmMap = mkTemp:Restore(displacedHmMap)
		
		local layer_canyon_gradient_6_FinalMap = mkTemp:Get()
		result.layers:Mul(canyonCutoffMap, hmCopy2Map, layer_canyon_gradient_6_FinalMap)
		hmCopy2Map = mkTemp:Restore(hmCopy2Map)
		
		result.layers:Mul(canyonCutoffMap, hmCopy3Map, heightmap)
		hmCopy3Map = mkTemp:Restore(hmCopy3Map)
		canyonCutoffMap = mkTemp:Restore(canyonCutoffMap)
	
		-- #################
		-- #### MIX
		result.mixingLayer = {
			backgroundMaterial = "usa/sand_red_01.lua", --## Layer 1.1a -- Desert plains A noise
			layers = {
				-- ### LAYER 1.1b
				-- Desert plains B noise
				{
					map = layer_1_1b_FinalMap,
					dither = true,
					material = "usa/sand_red_02.lua",
				},
				
				-- ### NOISE
				-- Edge detection
				{
					map = layer_special_edge_FinalMap,
					dither = true,
					material = "usa/scree_02.lua",
				},
				
				-- ### LAYER 0
				-- River bank material A
				{
					map = layer_0a_FinalMap,
					dither = true,
					material = "usa/sand_yellow.lua",
				},
				
				-- ### LAYER 1.2a
				-- Savannah plains A noise
				{
					map = layer_1_2a_FinalMap,
					dither = true,
					material = "usa/sand_yellow.lua",
				},
				{
					map = layer_1_2b_FinalMap,
					dither = true,
					material = "usa/sand_yellow_02.lua",
				},
				
				-- ### LAYER 2
				-- Mesa/ridge slopes
				{
					map = layer_2a_FinalMap,
					dither = true,
					material = "usa/sand_yellow.lua",
				},
				{
					map = layer_2b_FinalMap,
					dither = true,
					material = "usa/soil_sand_01.lua",
				},
				{
					map = layer_2c_FinalMap,
					dither = true,
					material = "usa/sand_yellow_02.lua",
				},
				
				-- ### LAYER 3
				-- Mesa top level
				{
					map = layer_3a_FinalMap,
					dither = true,
					material = "usa/forest_ground.lua",
				},
				{
					map = layer_3b_FinalMap,
					dither = true,
					material = "usa/grass_gravel.lua",
				},		
				
				--### LAYER 0
				-- River bank material B
				{
					map = layer_0b_FinalMap,
					dither = true,
					material = "usa/soil_sand_01.lua",
				},
				
				--### Special layer
				--Canyon gradient
				{
					map = layer_canyon_gradient_6_FinalMap,
					dither = true,
					material = "usa/soil_sand_01.lua",
				},
				{
					map = layer_canyon_gradient_5_FinalMap,
					dither = true,
					material = "usa/sand_red_01.lua",
				},
				{
					map = layer_canyon_gradient_4_FinalMap,
					dither = true,
					material = "usa/soil_sand_01.lua",
				},
				{
					map = layer_canyon_gradient_3_FinalMap,
					dither = true,
					material = "usa/forest_ground.lua",
				},
				{
					map = layer_canyon_gradient_1_FinalMap,
					dither = true,
					material = "usa/soil_sand_02.lua",
				},
				{
					map = heightmap, -- layer_canyon_gradient_2_FinalMap
					dither = true,
					material = "shared/grass_cutted_02.lua",
				},
				
				--### LAYER 4
				-- Ridge medium level
				{
					map = layer_4_FinalMap,
					dither = true,
					material = "usa/grass_gravel_02.lua",
				},
				
				--### LAYER 5
				-- Ridge high A/B level
				{
					map = layer_5a_FinalMap,
					dither = true,
					material = "usa/rock.lua",
				},
				{
					map = layer_5b_FinalMap,
					dither = true,
					material = "usa/grass_gravel_02.lua",
				},
				
				--### Slopes materials
				--## Mesa
				-- Mesa A
				{
					map = layer_slope_mesa_a_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_04.lua",
				},
				-- Mesa B
				{
					map = layer_slope_mesa_b_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_02.lua",
				},
				
				--## Ridge
				-- Rock A
				{
					map = layer_slope_rocky_a_FinalMap,
					dither = true,
					material = "usa/rock.lua",
				},
				-- Rock B
				{
					map = layer_slope_rocky_b_FinalMap,
					dither = true,
					material = "usa/scree.lua",
				},
				
				--## Canyon cliff
				-- Outer canyon A/B
				{
					map = layer_slope_canyon_outer_a_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_02.lua",
				},
				{
					map = layer_slope_canyon_outer_b_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_04.lua",
				},
				-- Inner canyon A/B
				{
					map = layer_slope_canyon_inner_a_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_01.lua",
				},
				{
					map = layer_slope_canyon_inner_b_FinalMap,
					dither = true,
					material = "usa/cliff_canyon_03.lua",
				},
				
				--### LAYER -2
				-- River bed
				{
					map = layer_river_bed_FinalMap,
					dither = true,
					material = "usa/sand_yellow_02.lua",
				},
			}
		}
		
		mkTemp:RestoreAll(result.mixingLayer)
		mkTemp:Finish()
		
		return result
	end
}

end