local tu = require "texutil"
local ffu = require "filefilterutil"
local legacyutil = require "legacyutil"
local modulesutil = require "modulesutil"
local osutil = require "osutil"
local transf = require "transf"
local vec3 = require "vec3"
-- local tableutil = require "tableutil"

game = {
	config = { },
	res = { }
}

game.config.costs = {
	-- per m^3
	terrainRaise = .75 * 6.0,
	terrainLower = .75 * 7.0,

	-- fraction of road/track cost
	railroadCatenary = .3,
	roadBusLane = .1,
	roadTramLane = .2,
	roadElectricTramLane = .4,
	
	bulldozeRefundTimeOut = 60.0,
	bulldozeRefundFactor = .75,
	
	removeField = 200000.0
}

game.config.ConstructWithModules = function(params) 
	local result 
	
	if params.constrScript ~= nil and params.constrScript.fileName ~= "" then
		local tab = game.res.script
		for key in string.gmatch(params.constrScript.fileName, "[^%.]+") do
			tab = tab[key]
		end
		result = tab(params.constrParams, params.constrScript.params)
	else
		result = game.res.construction[params.constrFn](params.constrParams)
	end
	result.slotToModels = {}
	
	local seed = params.constrParams.seed

	-- print(table.toString(params))
	
	if params.constrParams.modules ~= nil and result.slots ~= nil then
		
		local orderedIndex = {}
		for key in pairs(params.constrParams.modules) do
			table.insert(orderedIndex, key)
		end
		table.sort(orderedIndex)
	
		for ix, slotId in pairs(orderedIndex) do
			local mod = params.constrParams.modules[slotId]
			
			
			local slot = nil
			for i = 1, #result.slots do
				if result.slots[i].id == slotId then
					slot = i
					break
				end
			end
			if slot ~= nil or result.callInvalidModules then 
				local transform = slot and result.slots[slot].transf or nil
				local tag = "__module_" .. slotId
				local eye = transf.scale(vec3.new(1,1,1))
				local function addModel(name, mtransf, tag2)
					local loc = #result.models + 1
					result.models[loc] = { 
						id = name,
						transf = slot and transf.mul(transform, mtransf == nil and eye or mtransf) or nil,
						tag = tag2 or tag
					}
					return loc
				end
			
				if mod.updateScript ~= nil and mod.updateScript.fileName ~= "" then
					params.constrParams.seed = seed + slotId
					local tab = game.res.script
					for key in string.gmatch(mod.updateScript.fileName, "[^%.]+") do
						tab = tab[key]
					end
					tab(result, transform, tag, slotId, addModel, params.constrParams, mod.updateScript.params)
					
					modulesutil.addCosts(result, params.constrParams.modules[slotId])
				elseif game.res.module[mod.name] ~= nil then
					params.constrParams.seed = seed + slotId
					game.res.module[mod.name](result, transform, tag, slotId, addModel, params.constrParams)
					
					modulesutil.addCosts(result, params.constrParams.modules[slotId])
				end
			end
		end
		
		if result.terminateConstructionHook then
			result.terminateConstructionHook()
		end
	end
	
	--print(params.constrFn)
	legacyutil.convertGroundTextureKeys(result)
	
	return result
end

--[[game.config.cargoLoadIndicators = {
	{ id = "SMALL", size = { 2.0, 2.0, 1.0 } }
}]]

game.config.scaffold = {
	era_a = {
		scaffold = {"asset/construction/scaffolding/era_a_normal.mdl", "asset/construction/scaffolding/era_a_ladder.mdl"},
		crane = {"asset/construction/crane/era_b_undercarriage.mdl", 
			"asset/construction/crane/era_b_mast.mdl", 
			"asset/construction/crane/era_b_slewing_platform.mdl", 
			"asset/construction/crane/era_b_slewing_ring_support.mdl", 
			"asset/construction/crane/era_b_tie_in.mdl", 
		}
	},
	era_b = {
		scaffold = {"asset/construction/scaffolding/era_b_normal.mdl", "asset/construction/scaffolding/era_b_ladder.mdl"},
		crane = {"asset/construction/crane/era_b_undercarriage.mdl", 
			"asset/construction/crane/era_b_mast.mdl", 
			"asset/construction/crane/era_b_slewing_platform.mdl", 
			"asset/construction/crane/era_b_slewing_ring_support.mdl", 
			"asset/construction/crane/era_b_tie_in.mdl", 
		}
	},
	era_c = {
		scaffold = {"asset/construction/scaffolding/era_b_normal.mdl", "asset/construction/scaffolding/era_b_ladder.mdl"},
		crane = {"asset/construction/crane/era_b_undercarriage.mdl", 
			"asset/construction/crane/era_b_mast.mdl", 
			"asset/construction/crane/era_b_slewing_platform.mdl", 
			"asset/construction/crane/era_b_slewing_ring_support.mdl", 
			"asset/construction/crane/era_b_tie_in.mdl", 
		}
	},
}

game.config.environment = "temperate.lua"
game.config.climate = "temperate.clima.lua"

game.config.terrain = {
	lodErrorMultiplier = 1.0
}

game.config.nameList = {
	folder = ""
}

game.config.loadspeedPenaltyForTrainOverlength = true

game.config.earnAchievementsWithMods = false

game.config.industryButton = false
game.config.sandboxButton = false

game.config.difficulty = "EASY"

game.config.noCosts = false

game.config.terrainToolMinStrength = 5
game.config.terrainToolMaxStrength = 100
game.config.terrainToolMaxSize = 16
game.config.terrainPainterMaxSize = 256
game.config.terrainToolMaxSizeEditor = 256
game.config.terrainPainterMaxSizeEditor = 256
game.config.assetBrushMaxSize = 256
if osutil.getConsoleGen() < 2 then
	game.config.assetBrushMaxSize = 128
end

game.config.enforceMainConnections = true

game.config.townDevelopInterval = 60
game.config.chargeMaintenanceInterval = 60

game.config.simulateCargoWeight = true
game.config.simPersonDestinationRecomputationProbability = 1.0

game.config.townMajorStreetAngleRange = .0		-- angle within town major street directions are randomized (in degrees)
game.config.townInitialMajorStreetAngleRange = 0.0		-- the same, but only during first creation of a town

game.config.tramCatenaryYearFrom = 1875
game.config.trackCatenaryYearFrom = 1910
game.config.busLaneYearFrom = 1925

game.config.maxVehicleCloneAmount = 50

game.config.trainAccelerationFactor = 1.0
game.config.trainBrakeDeceleration = 2.5

game.config.gui =  {

	layers = {

		defaultColors = {
			baseTerrainColor = { 0.82, 0.82, 0.82, 1.0 },
			baseWaterColorFactors = { 0.5, 0.5, 0.5, 0.25 },
			entityColorFactor = 0.33
		},

		contourLines = {
			numLevels = 6,
			baseTerrainColor = { 0.82, 0.82, 0.82, 1.0 },
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			terrainMinColor = { .82, .82, .82, 1.0 },
			terrainMaxColor = { .235, .54, .25, 1.0 },
			waterColor = { .47, .64, .76, 1.0 },
			contours = {
				{ id = "majorContour", name = _("Major contour (100 m)"), color = { .05, .05, .05, .5 }, level = 100.0, width = 1.5, fadeDist = -1.0 },
				{ id = "minorContour", name = _("Minor contour (50 m)"), color = { .05, .05, .05, .5 }, level = 50.0, width = .75, fadeDist = -1.0 },
				{ id = "intermediateContour", name = _("Intermediate contour (10 m)"), color = { .2, .125, .0, .5 }, level = 10.0, width = .75, fadeDist = 4000.0 },
				{ id = "detailContour", name = _("Detail contour (2 m)"), color = { .2, .125, .0, .5 * 0.3 }, level = 2.0, width = .75, fadeDist = 500.0 }
			}
		},
		
		navigableWaters = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			navigableWaterColor = { 0.435, 0.827, 0.380, 1.0},
			baseWaterColor = { 0.318, 0.494, 0.600, -0.85},
		},

		landUse = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			residentialColors = { { 0.729, 0.800, 0.690, 1.0 }, { 0.525, 0.847, 0.345, 1.0 }, },
			commercialColors = { { 0.729, 0.804, 0.816, 1.0 }, { 0.369, 0.839, 0.906, 1.0 }, },
			industrialColors = { { 0.875, 0.875, 0.769, 1.0 }, { 0.875, 0.875, 0.384, 1.0 }, }
		},

		trackSpeedLimits = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			numLevels = 5,
			tunnelOutlineSize = 2.0,
			tunnelOutlineColor = { 0.0, 0.0, 0.0, 0.3 },
			speedLimitColors = { { 1.0, 0.6, 0.6, 1.0}, { 0.8, 0.6, 1.0, 1.0 }, { 0.6, 0.8, 1.0, 1.0 }, },
		},

		destinations = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			residentialColor = { 0.4, 0.4, 0.4, 1.0 },
			destinationColor = { 1.0, 1.0, 1.0, 1.0 },
			
			publicTransportColors = { {0.8, 1.0, 0.8, 1.0}, {0.0, 1.0, 0.0, 1.0} },
			privateTransportColors = { {0.8, 0.8, 1.0, 1.0}, {0.0, 0.0, 1.0, 1.0} },
	
			numTransportLevels = 5,
		},

		cargo = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
	
			transportColors = { {0.8, 1.0, 0.8, 1.0}, {0.0, 1.0, 0.0, 1.0} },
			residentialColors = { { 0.729, 0.800, 0.690, 1.0 }, { 0.525, 0.847, 0.345, 1.0 }, },
			commercialColors = { { 0.729, 0.804, 0.816, 1.0 }, { 0.369, 0.839, 0.906, 1.0 }, },
			industrialColors = { { 0.875, 0.875, 0.769, 1.0 }, { 0.875, 0.875, 0.384, 1.0 }, },
			
			numTransportLevels = 5,
			numBuildingLevels = 3
		},
	
		stations = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			stationColors = { { 1.0, 0.6, 0.6, 1.0}, { 0.8, 0.6, 1.0, 1.0 }, { 0.6, 0.8, 1.0, 1.0 }, },
			numLevels = 5,
		},

		streetTraffic = {
			baseEntityColor = { 1.0, 1.0, 1.0, 1.0 },
			trafficColors = { { 1.0, 0.6, 0.6, 1.0}, { 0.8, 0.6, 1.0, 1.0 }, { 0.6, 0.8, 1.0, 1.0 }, },
			numLevels = 5,
		},

		emissions = {
			baseTerrainColor = { 0.82, 0.82, 0.82, 1.0 },
			baseEntityColor = { 1.0, 1.0, 1.0, -1.0 },
			residentialColor = { 0.4, 0.4, 0.4, 1.0 },
			emissionColors = { { 0.82, 0.82, 0.82, 1.0 }, { 1.0, 0.0, 0.0, 1.0 } },
			numLevels = 17
		}
	
	},

	contourLinesConfig = { -- Deprecated, use layers.contourLines instead
		contours = { }
	},

	signConfig = {
		signRenderDistance = 1500.0,
		signBackgroundTintColor = { 1.0, 1.0, 1.0, 1.0 },
		signTextColor = { 0.9, 0.9, 0.9, 1.0 },
	},

	iconRenderDistances = {
		trains = 1.0,
		roadVehicles = 1.0,
		planes = 1.0,
		ships = 1.0,
		stations = 1.0,
		depots = 1.0,
		signals = 1.0,
		towns = 1.0,
		townBuildingsCargo = 1.0,
		industries = 1.0,
		costs = 1.0,
	},

	defaultChartColors = {
		{ .6, .8, 1.0, 1.0 },
		{ 1.0, .6, .6, 1.0},
		{ .525, .847, .345, 1.0 },
		{ .369, .839, .906, 1.0 },
		{ .875, .875, .384, 1.0 }
	},

	incomeCostsChartColors = { { .6, .8, 1.0, 1.0 }, { 1.0, .6, .6, 1.0} },
	loadedUnloadedChartColors = { { .6, .8, 1.0, 1.0 }, { 1.0, .6, .6, 1.0} },
	landUseChartColors = { { .525, .847, .345, 1.0 }, { .369, .839, .906, 1.0 }, { .875, .875, .384, 1.0 } },
	
	lineColors = {
		{ 94/255, 47/255, 0/255 },
		{ 84/255, 0/255, 0/255 },
		{ 84/255, 0/255, 84/255 },
		{ 0/255, 0/255, 84/255 },
		{ 0/255, 47/255, 84/255 },
		{ 0/255, 84/255, 84/255 },
		{ 0/255, 84/255, 0/255 },
		{ 0/255, 51/255, 18/255 },
		{ 84/255, 84/255, 0/255 },
		{ 62/255, 41/255, 35/255 },
		
		{ 153/255, 76/255, 0/255 },
		{ 153/255, 0/255, 0/255 },
		{ 153/255, 0/255, 153/255 },
		{ 0/255, 0/255, 153/255 },
		{ 0/255, 84/255, 153/255 },
		{ 0/255, 153/255, 153/255 },
		{ 0/255, 153/255, 0/255 },
		{ 0/255, 89/255, 31/255 },
		{ 153/255, 153/255, 0/255 },
		{ 89/255, 65/255, 55/255 },
		
		{ 255/255, 127/255, 0/255 },
		{ 255/255, 0/255, 0/255 },
		{ 255/255, 0/255, 255/255 },
		{ 0/255, 0/255, 255/255 },
		{ 0/255, 150/255, 255/255 },
		{ 0/255, 255/255, 255/255 },
		{ 0/255, 255/255, 0/255 },
		{ 0/255, 150/255, 53/255 },
		{ 255/255, 255/255, 0/255 },
		{ 124/255, 99/255, 85/255 },
		
		{ 255/255, 178/255, 102/255 },
		{ 255/255, 102/255, 102/255 },
		{ 255/255, 102/255, 255/255 },
		{ 102/255, 102/255, 255/255 },
		{ 121/255, 186/255, 255/255 },
		{ 127/255, 255/255, 255/255 },
		{ 115/255, 255/255, 115/255 },
		{ 82/255, 177/255, 105/255 },
		{ 255/255, 255/255, 115/255 },
		{ 164/255, 141/255, 121/255 },
		
		{ 255/255, 208/255, 161/255 },
		{ 255/255, 171/255, 171/255 },
		{ 255/255, 171/255, 255/255 },
		{ 171/255, 171/255, 255/255 },
		{ 180/255, 216/255, 225/255 },
		{ 184/255, 255/255, 255/255 },
		{ 171/255, 255/255, 171/255 },
		{ 143/255, 199/255, 148/255 },
		{ 255/255, 255/255, 171/255 },
		{ 212/255, 197/255, 174/255 },
	},
	
	modifierColors = {
		{ 1.0, .0, .0, .3 },
		{ 1.0, .0, .0, .4 }, 	-- tunnel edges
		{ 1.0, .0, .0, .6 }, 	-- proposal
		{ 1.0, .0, .0, .75 }, 	-- proposal: tunnel edges
		{ .0, .4, 1.0, .4 },
		{ .0, .4, 1.0, .5 },  	-- tunnel edges
		{ .0, .4, 1.0, .6 }, 	-- proposal
		{ .0, .4, 1.0, .75 }  	-- proposal: tunnel edges
	}
}

game.config.audio = {
	environment = {
		lake = { name = "environment/Lake3.wav", refDist = 5.0 },
		birds = { name = "environment/birds3.wav", refDist = 1.0 },
		forest = { name = "environment/woods.wav", refDist = 5.0 },
		meadow = { name = "environment/Meadow2.wav", refDist = 5.0 },
		mountain = { name = "environment/Mountains3.wav", refDist = 5.0 },
		commercial1850 = { name = "environment/Commercial_1850.wav", refDist = 5.0 },
		commercial1920 = { name = "environment/Commercial_1920.wav", refDist = 5.0 },
		commercial1990 = { name = "environment/Commercial_1990.wav", refDist = 5.0 },
		industrial1850 = { name = "environment/Industrial_1850.wav", refDist = 5.0 },
		industrial1920 = { name = "environment/Industrial_1920.wav", refDist = 5.0 },
		industrial1990 = { name = "environment/Industrial_1990.wav", refDist = 5.0 },
		residential1850 = { name = "environment/Residential_1850.wav", refDist = 5.0 },
		residential1920 = { name = "environment/Residential_1920.wav", refDist = 5.0 },
		residential1990 = { name = "environment/Residential_1990.wav", refDist = 5.0 },
		crowd = { name = "environment/Crowd_large.wav", refDist = 5.0 },
		traffic1850 = { name = "environment/traffic_1850.wav", refDist = 60.0, height = 120.0 },
		traffic1920 = { name = "environment/traffic_1920.wav", refDist = 60.0, height = 120.0 },
		traffic1990 = { name = "environment/traffic_1990.wav", refDist = 60.0, height = 120.0 },
		atmosphere = { name = "environment/Wind.wav", refDist = 3500.0 }
	},
	music = {
		-- Deprecated, use playlists instead
	}
}

game.config.locations = {
		town = {
				maxNumberPerArea = 0.2,			-- km^(-2)
			    allowInRoughTerrain = false
		},
		
		industry = {
			absoluteMinimum = 5,
			maxNumberPerArea = 0.8,			    -- km^(-2)
			targetMaxNumberPerArea = 0.8,		-- km^(-2)
		},
		
		makeInitialStreets = true				-- default true, false experimental
}

game.config.animal = {
	populationDensityMultiplier = 1,            -- All population densisties (in km^2) are multiplied by this value
	useLocalSpawning = true,                    -- Spawning is done in subgrids of size 'localTileSize'
	                                            -- Distribution is closer to the chosen density, but less uniform
	localTileSize = 1000.0,                     -- Size on local spawning grid
	notifyAnimalDespawn = true,                 -- Play a notification when animal despawns
}

game.config.settings = {
	geometryQualityOptions = {
		{ viewNearFar = { 4.0, 5000.0 }, fogStartEndFarPerc = { .45, 1.0 }, lodDistanceScaling = .5 },		-- Low
		{ viewNearFar = { 4.0, 6000.0 }, fogStartEndFarPerc = { .33, 1.0 }, lodDistanceScaling = .75 },		-- Medium
		{ viewNearFar = { 4.0, 7500.0 }, fogStartEndFarPerc = { .25, 1.0 }, lodDistanceScaling = 1.0 },		-- High
		{ viewNearFar = { 4.0, 15000.0 }, fogStartEndFarPerc = { .125, 1.0 }, lodDistanceScaling = 10 },	-- Camera tool
		{ viewNearFar = { 0.5, 5000.0 }, fogStartEndFarPerc = { 1.0, 1.0 }, lodDistanceScaling = 1.0 },		-- Cockpit view
	}
}

game.config.particles = {
    textures = {
        noise0 = "particle_noise0.dds",
        noise1 = "particle_noise1.dds",
        smoke = "particle_smoke.dds",
        smokeNormal = "particle_smoke_normal.dds",
    },
}

game.config.water = {
    textures = {
        foamNormal = "effects/water_foam_normal.dds",
        foamDetail = "effects/water_foam_detail.dds",
        foam = "effects/water_foam.dds",
    }
}

game.config.economy = {
	industryDevelopment = {
		spawnTargetTimeSpan = 50 * 365.25 * 2000,
		spawnProbabilityExponent = 3.0,
		spawnIndustries = false,
		unusedTimeSpan = 10 * 365.25 * 2000,
		closureCountdownTimeSpan =  730.5 * 2000,
		closureProbability = 1,
	},
	townDevelopment = {
		cargoNeedsPerTown = 2,
	}
}

game.config.advancedOptions = {
	maximumLoanScale = 1.0,
	loanInterestScale = 1.0,
	publicTransportDestinationsSensitivityScale = 1.0,
	privateTransportDestinationsSensitivityScale = 1.0,
	cargoSupplySensitivityScale = 1.0,
	emissionSensitivityScale = 1.0,
	trafficSpeedSensitivityScale = 1.0,
	stationOverflowSensitivityScale = 1.0,
}

addFileFilter("model/vehicle", ffu.model.vehicle)
addFileFilter("model/person", ffu.model.person)
addFileFilter("model/car", ffu.model.car)
addFileFilter("model/rock", ffu.model.rock)
addFileFilter("model/tree", ffu.model.tree)
addFileFilter("model/signal", ffu.model.signal)
addFileFilter("model/animal", ffu.model.animal)
addFileFilter("model/other", ffu.model.other)
