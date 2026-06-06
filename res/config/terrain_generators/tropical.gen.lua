local maputil = require "maputil"
local mapgenutil = require "terrain/mapgenutil"
local mathutil = require "mathutil"
local tropicalassetsgen = require "terrain/tropicalassetsgen"
local layersutil = require "terrain/layersutil"

function data() 

return {
	climate = "tropical.clima.lua",
	order = 2,
	name = _("Tropical"),
	params = {
		{
			key = "hilliness",
			name = _("Hilliness"),
			values = { "", "", "", "", "" },
			defaultIndex = 2,
			uiType = "SLIDER",
		},
		{
			key = "land",
			name = _("Mainland"),
			values = { "", "", "", "", "" },
			defaultIndex = 2,
			uiType = "SLIDER",
		},
		{
			key = "forest",
			name = _("Forest"),
			values = { "", "", "", "", "", "", "", },
			defaultIndex = 3,
			uiType = "SLIDER",
		},
		{
			key = "islands",
			name = _("Islands"),
			values = { "", "", "", "", "", "", "", },
			defaultIndex = 3,
			uiType = "SLIDER",
		},
	},
	updateFn = function(params)
		-- local layersutil = dofile("./res/scripts/terrain/layersutil.lua")
		-- local tropicalassetsgen = dofile("./res/scripts/terrain/tropicalassetsgen.lua")
		local result = {
			parallelFactor = 32,
			layers = layersutil.Layer.new(),
			heightmapLayer = "HM",
		}
		
		-- #################
		-- #### CONFIG
		local hillyness = params.hilliness / 3
		local land = params.land / 4
		local islands = params.islands / 7
		local humidity = params.forest / 13 -- reduce number of trees
		
		local innerIslandRadius = 0.5
		local mainIslandAmount = math.map(land, 0, 1, 200, 600)
		local primarySize = math.map(land, 0, 1, 0.41 + 0.008, 0.41 - 0.008)
		
		local outerIslandsMinRadius = 0.8
		local outerIslandsMaxRadius = 0.99
		local secondaryIslandsAmount = math.map(islands, 0, 1, 0, 200)
		local secondarySize = math.map(land, 0, 1, 0.412 + 0.004, 0.412 - 0.004) -- higher means less (lowest is 0.4 / 0.409)
		
		local nRidges = math.map(hillyness, 0, 1, 1, 1)

		local flatness = math.map(hillyness, 0, 1, 1.0 / 2000.0, 1.0 / 5000.0) --  size of flatness spots, 1.0 / 2000.0 minium
		local flatnessOffs = -0.0 -- less or more flat spots, from -1 (more) to 1 (less)
		
		local flatDistance = math.map(hillyness, 0, 1, 100, 20)
		
		local waterRise = 0.0
		local distanceDisplacementSize = 185
		local distanceDisplacementOff = -0.5
		local distanceNegDisplacementSize = 185
		local distanceNegDisplacementOff = 0.5
		
		local ridgeScaling = math.map(hillyness, 0, 1, 1.1, 1.5)
		local cliffScaling = 0.1 -- scale height of cliffs
		local cliffScalingNeg = 0.1 / 50 -- scale height of cliffs
		local cliffLowerCutoff = -0.4 -- higher means less cliffs (-0.4)
		local cliffUpperCutoff = 0.1 -- lower means less cliffs
		
		local cliffProfileX = {0, 3, 10, 30, 35, 200, 250, 300, 310}
		local cliffProfileY = { 0, 0, cliffScaling * 0.1, cliffScaling * 0.9, 
			cliffScaling, cliffScaling * 0.2, cliffScaling * 0.1, 0, 0}
		local cliffProfileXNeg = {0, 3, 7, 25, 30, 200, 250, 300, 310}
		local cliffProfileYNeg = { 0, 0, -cliffScalingNeg * 0.1, -cliffScalingNeg * 0.9, 
			-cliffScalingNeg, -cliffScalingNeg * 0.2, -cliffScalingNeg * 0.1, -0, -0}
			
		local shoreDepth = {0, -10, -13, -13}
		
		local ridgeNoiseStrength = 10 -- 20 is lots of noise
		
		local noiseStrength = 4 -- (8 is somewhat noisy, 0 is no extra noise)
		
		local ridgeBaseSize = 1
		
		local innerRingSeeds = {}
		for pts = 1, mainIslandAmount do
			innerRingSeeds[#innerRingSeeds + 1] = {
				params.mapSizeX / 2 + params.mapSizeX * (math.random() * 2 - 1) / 2 * innerIslandRadius, 
				params.mapSizeY / 2 + params.mapSizeY * (math.random() * 2 - 1) / 2 * innerIslandRadius
			}
		end
		local annulusSeeds = {}
		for pts = 1, secondaryIslandsAmount do
			local r = math.map(math.random(), 0, 1, outerIslandsMinRadius, outerIslandsMaxRadius)
			local theta = math.random() * math.pi * 2
			annulusSeeds[#annulusSeeds + 1] = {
				params.mapSizeX / 2 + params.mapSizeX / 2 * r * math.sin(theta),
				params.mapSizeY / 2 + params.mapSizeY / 2 * r * math.cos(theta)
			}
		end
		
		local ridgesConfig = {
			bounds = params.bounds,
			minHeight = 0 + 100 * hillyness,
			maxHeight = 75 + 150 * hillyness,
			probabilityLow = .0,
			probabilityHigh = .0,
			density = nRidges
		}
		local ridges = mapgenutil.MakeRidges(ridgesConfig)
		local cliffs = mapgenutil.MakeRidges(ridgesConfig)
		
		-- #################
		-- #### PREPARE
		local mkTemp = layersutil.TempMaker.new()
		
		-- #################
		-- #### MAIN ISLAND
		local noiseMap = mkTemp:Get()
		result.layers:WhiteNoise(noiseMap, primarySize)
		
		result.layers:Constant(result.heightmapLayer, 0)
		local temp1 = mkTemp:Get()
		result.layers:Points(temp1, innerRingSeeds, -1)
		result.layers:Percolation(noiseMap, temp1, temp1, {
			seedThreshold = -0.5,
			noiseThreshold = 0.5,
			maxCluster = 40000,
		})
		
		-- #################
		-- #### SECONDARY ISLANDS
		local t3 = mkTemp:Get()
		result.layers:WhiteNoise(noiseMap, secondarySize)
		result.layers:Points(t3, annulusSeeds, -1)
		
		result.layers:Percolation(noiseMap, t3, t3, {
			seedThreshold = -0.5,
			noiseThreshold = 0.5,
			maxCluster = 40000,
		})
		noiseMap = mkTemp:Restore(noiseMap)
		-- MAKE ISLANDS
		result.layers:Map(t3, t3, {0, 1}, {0, 20}, false)
		
		-- MIX ISlANDS
		result.layers:Add(temp1, t3, temp1)
		t3 = mkTemp:Restore(t3)
		
		-- #################
		-- #### PREPARE PROFILE
		do
			local t3 = mkTemp:Get()
			result.layers:Distance(temp1, temp1)	
			result.layers:RidgedNoise(t3, { octaves = 6, frequency = 1.0 / 5000.0, lacunarity = 4.5, gain = 0.4})
			
			result.layers:Map(t3, t3, {0, 2}, { 110, -110}, true)
			result.layers:Add(temp1, t3, temp1)
			t3 = mkTemp:Restore(t3)
		end
		
		-- #################
		-- #### PREARE SUBDIVISION (TERRAIN and WATER parts)
		result.layers:Map(temp1, temp1, {70, 120}, { -4, 4}, true)
		
		local hmNgMap = mkTemp:Get()
		result.layers:Map(temp1, hmNgMap, {4, -4}, { -4, 4}, false)
		local distanceMap = mkTemp:Get()
		result.layers:Distance(temp1, distanceMap)
		result.layers:Distance(hmNgMap, hmNgMap)
		
		local cutoffCliffMap = mkTemp:Get()
		local cutoffCliffNgMap = mkTemp:Get()
		result.layers:Pwlerp(distanceMap, cutoffCliffMap, cliffProfileX, cliffProfileY)
		
		result.layers:Pwlerp(hmNgMap, cutoffCliffNgMap, cliffProfileXNeg, cliffProfileYNeg)
		
		do
			local t3 = mkTemp:Get()
			result.layers:CutoffNoise(t3, {
				frequency = 1.0 / 5000, scale = 1, lowerCutoff = cliffLowerCutoff, upperCutoff = cliffUpperCutoff
			})
			
			result.layers:Mad(cutoffCliffMap, t3, cutoffCliffMap)
			result.layers:Mad(cutoffCliffNgMap, t3, cutoffCliffNgMap)
			mkTemp:Restore(t3)
		end
		
		-- #################
		-- #### DISPLACE A BIT HM
		do
			local t3 = mkTemp:Get()
			result.layers:CutoffNoise(t3, { frequency = 1.0 / 2000, scale = 1,
				lowerCutoff = -0.75 + distanceDisplacementOff,
				upperCutoff = 0.25 + distanceDisplacementOff,
			})
			result.layers:Map(t3, t3, {0, 1}, { -distanceDisplacementSize, distanceDisplacementSize}, true)
			
			local t4 = mkTemp:Get()
			result.layers:Map(distanceMap, t4, {1, distanceDisplacementSize}, { 0.1, 0.8}, true)
			
			result.layers:Mad(t4, t3, distanceMap)
			mkTemp:Restore(t4)
			mkTemp:Restore(t3)
		end
		
		-- #################
		-- #### SMOOTHEN TERRAIN
		result.layers:Pwlerp(distanceMap, temp1, {0, 10, flatDistance, flatDistance + 10}, {0, 5, 10, 20})
		
		result.layers:Map(temp1, temp1, {0, 600}, { 0, 1}, true)
		result.layers:Herp(temp1, temp1, {0, 1}, { 0, 0})
		
		result.layers:Map(temp1, temp1, {0, 1}, { 0, 1}, true)
		
		-- #################
		-- #### DISPLACE A BIT HM
		do
			local t3 = mkTemp:Get()
			result.layers:CutoffNoise(t3,
				{ frequency = 1.0 / 2000, scale = 1, lowerCutoff = -0.75 + distanceNegDisplacementOff, upperCutoff = 0.25 + distanceNegDisplacementOff}
			)
			result.layers:Map(t3, t3, {0, 1}, { -distanceNegDisplacementSize, distanceNegDisplacementSize}, true)
			
			local t4 = mkTemp:Get()
			result.layers:Map(hmNgMap, t4, {4, distanceNegDisplacementSize}, { 0, 0.5}, true)
			
			result.layers:Mad(t4, t3, hmNgMap)
			mkTemp:Restore(t4)
			mkTemp:Restore(t3)
		end
		
		-- #################
		-- #### SMOOTHEN NEG
		result.layers:Pwlerp(hmNgMap, hmNgMap, {0, 80, 240, 260}, shoreDepth)
		
		result.layers:Map(hmNgMap, hmNgMap, {-20, 0}, { 0, 1}, true)
		
		result.layers:Herp(hmNgMap, hmNgMap, {0, 1}, { 0, 0})
		result.layers:Map(hmNgMap, hmNgMap, {0, 1}, { -1, 0}, true)
		
		-- #################
		-- #### UNDERWATER NOISE
		do
			local t3 = mkTemp:Get()
			result.layers:RidgedNoise(t3, { octaves = 6, frequency = 1.0 / 10000.0, lacunarity = 2.4, gain = 1.7})
			
			result.layers:Map(t3, t3, {0, 1}, { 0, 0.5}, false)
			result.layers:Mad(hmNgMap, t3, hmNgMap)
			mkTemp:Restore(t3)
		end
			
		-- #################
		-- #### PREPARE BASE
		result.layers:Map(temp1, temp1, {0, 1}, { 0, 3}, false)
		
		-- #################
		-- #### PREPARE CUTOFF (POSITIVE MAP)
		local cutoffPosMap = mkTemp:Get()
		result.layers:Map(temp1, cutoffPosMap, {0, 4}, { 0, 16}, true)
		
		-- #################
		-- #### GOOD NOISE - FLAT SPOTS
		do
			local t3 = mkTemp:Get()
			result.layers:CutoffNoise(t3, 
				{ frequency = flatness, scale = 1.0, lowerCutoff = -0.75 + flatnessOffs, upperCutoff = 0.25 + flatnessOffs }
			)
			result.layers:Mul(temp1, t3, temp1)
			mkTemp:Restore(t3)
		end
		
		local cutoffMap = mkTemp:Get()
		result.layers:Map(temp1, cutoffMap, {0, 4}, { 0, ridgeScaling}, true)
		
		-- #################
		-- #### ADD SOME NOISE
		do
			local t3 = mkTemp:Get()
			result.layers:RidgedNoise(t3, { octaves = 6, frequency = 1.0 / 5000.0, lacunarity = 1.4, gain = 1.1})
			
			result.layers:Mad("CUTOFF_POS", t3, temp1)
			mkTemp:Restore(t3)
		end
		result.layers:Copy(temp1, result.heightmapLayer)
		temp1 = mkTemp:Restore(temp1)
		
		-- #################
		-- #### RIDGES
		local ridgesMap
		do
			local t3 = mkTemp:Get()
			result.layers:Ridge(t3, {
				ridges = ridges,
				noiseStrength = ridgeNoiseStrength,
				baseSize = ridgeBaseSize
			})
			ridgesMap = mkTemp:Get()
			result.layers:Mul(cutoffMap, t3, ridgesMap)
			
			cutoffMap = mkTemp:Restore(cutoffMap)
			mkTemp:Restore(t3)
		end
		result.layers:Add(ridgesMap, result.heightmapLayer, result.heightmapLayer)
		
		-- #################
		-- #### CLIFFS
		do
			local t3 = mkTemp:Get()
			result.layers:Ridge(t3, {
				ridges = cliffs,
				noiseStrength = ridgeNoiseStrength,
			})
			result.layers:Mad(cutoffCliffMap, t3, result.heightmapLayer)
			cutoffCliffMap = mkTemp:Restore(cutoffCliffMap)
			
			result.layers:Mad(cutoffCliffNgMap, t3, hmNgMap)
			cutoffCliffNgMap = mkTemp:Restore(cutoffCliffNgMap)
			mkTemp:Restore(t3)
		end
		
		-- #################
		-- #### ADD ANOTHER NOISE
		local t3 = mkTemp:Get()
		result.layers:RidgedNoise(t3, {octaves = 5, frequency = 1 / 444, lacunarity = 2.2, gain = 0.8})
		
		local t4 = mkTemp:Get()
			result.layers:Map(cutoffPosMap, t4, {0, 4}, { 0, noiseStrength}, true)
			cutoffPosMap = mkTemp:Restore(cutoffPosMap)
			
			result.layers:Mad(t4, t3, result.heightmapLayer)
		t4 = mkTemp:Restore(t4)
		
		-- MERGE WATER AND TERRAIN
		result.layers:Map(hmNgMap, hmNgMap, {0, 1}, { 0, 50}, false)

		result.layers:Add(result.heightmapLayer, hmNgMap, result.heightmapLayer)
		hmNgMap = mkTemp:Restore(hmNgMap)
		
		result.layers:Constant(t3, -waterRise)
		
		result.layers:Add(result.heightmapLayer, t3, t3)
		
		result.layers:Gauss(t3, result.heightmapLayer, 2)
		t3 = mkTemp:Restore(t3)
		
		-- #################
		-- #### ASSETS
		local config = {
			noWater = humidity == 0,
			humidity = humidity,
		}
		
		result.forestMap, result.treesMapping, result.assetsMap, result.assetsMapping = tropicalassetsgen.Make(
			result.layers, config, mkTemp, result.heightmapLayer, ridgesMap, distanceMap
		)
		
		-- #################
		-- #### FINISH
		ridgesMap = mkTemp:Restore(ridgesMap)

		distanceMap = mkTemp:Restore(distanceMap)
		mkTemp:Restore(result.forestMap)
		mkTemp:Restore(result.assetsMap)
		mkTemp:Finish()
		-- maputil.PrintGraph(result)

		return result
	end
}

end
