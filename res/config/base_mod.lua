local ffu = require "filefilterutil"
local metadatautil = require "metadatautil"
local osutil = require "osutil"

local function getGen()
	return osutil.getConsoleGen()
end

local function getMapSizePerGen()
	return {
		{ pGetText("map-size", "Small"), pGetText("map-size", "Medium"), },
		{ pGetText("map-size", "Small"), pGetText("map-size", "Medium"), pGetText("map-size", "Large"), },
		{ pGetText("map-size", "Small"), pGetText("map-size", "Medium"), pGetText("map-size", "Large"), pGetText("map-size", "Very Large"), },
	}
end

local function getTownsFrequencyPerGen()
	return {
		{ pGetText("map-town-density", "Low"), pGetText("map-town-density", "Medium"), pGetText("map-town-density", "High"), },                 
		{ pGetText("map-town-density", "Low"), pGetText("map-town-density", "Medium"), pGetText("map-town-density", "High"), },                 
		{ pGetText("map-town-density", "Low"), pGetText("map-town-density", "Medium"), pGetText("map-town-density", "High"), pGetText("map-town-density", "Very high"), }, 
	}
end

local function getIndustryMaxNumberPerAreaPerGen()
	return {
		{ pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), }, 				 
		{ pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), }, 				 
		{ pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), pGetText("map-industry-density", "Very high"), },
	}	
end

local function getTargetMaxNumberPerAreaPerGen()
	return {
		{ pGetText("map-industry-density", "Disabled"), pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), },			 
		{ pGetText("map-industry-density", "Disabled"), pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), },	 
		{ pGetText("map-industry-density", "Disabled"), pGetText("map-industry-density", "Low"), pGetText("map-industry-density", "Medium"), pGetText("map-industry-density", "High"), pGetText("map-industry-density", "Very high"), },
	}	
end

local function getSensitivityScalePerGen()
	return {
		{ _("0%"), _("25%"), _("50%"), _("75%"), _("100%"), _("125%"), },                                  
		{ _("0%"), _("25%"), _("50%"), _("75%"), _("100%"), _("125%"), },                                  
		{ _("0%"), _("25%"), _("50%"), _("75%"), _("100%"), _("125%"), _("150%"), _("175%"), _("200%"), },
	}
end

local function getVehiclesPerGen()
	return {
		{ { "europe", _("European") }, { "usa", _("American") }, { "asia", _("Asian") } },                     
		{ { "europe", _("European") }, { "usa", _("American") }, { "asia", _("Asian") }, { "all", _("All") }, }, 
		{ { "europe", _("European") }, { "usa", _("American") }, { "asia", _("Asian") }, { "all", _("All") },  }, 
	}
end

local function getDefaultIndex(valuesList, value)
	for i, v in ipairs(valuesList) do
        if v == value then
            return i - 1
        end
    end
    return 0
end

function data()
return {
	info = {
		params = {
			{
				key = "locations.mapSize",
				name = _("Map size"),
				tooltip = _("Map size"),
				values = getMapSizePerGen()[getGen()],
				defaultIndex = getDefaultIndex(getMapSizePerGen()[getGen()], pGetText("map-size", "Small")),
			},
			{
				key = "locations.towns.frequency",
				name = _("Towns"),
				tooltip = _("Number of towns"),
				values = getTownsFrequencyPerGen()[getGen()],
				defaultIndex = getDefaultIndex(getTownsFrequencyPerGen()[getGen()], pGetText("map-town-density", "Medium")),
			},
			{
				key = "locations.industry.maxNumberPerArea",
				name = _("Number of industries"),
				tooltip = _("Initial industry density on the map"),
				values = getIndustryMaxNumberPerAreaPerGen()[getGen()],
				defaultIndex = getDefaultIndex(getIndustryMaxNumberPerAreaPerGen()[getGen()], pGetText("map-industry-density", "Medium")),
			},
			{
				key = "locations.industry.targetMaxNumberPerArea",
				name = _("Industry density target"),
				tooltip = _("Target value for number of industries"),
				values = getTargetMaxNumberPerAreaPerGen()[getGen()],
				uiType = "COMBOBOX",
				defaultIndex = getDefaultIndex(getTargetMaxNumberPerAreaPerGen()[getGen()], pGetText("map-industry-density", "Medium")),
			},
			{
				key = "advancedOptions.maximumLoanScale",
				name = _("Maximum loan"),
				tooltip = _("The maximum amount of money that can be borrowed from the bank"),
				values = { _("50%"), _("75%"), _("100%"), _("125%"), _("150%"),},
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "advancedOptions.loanInterestScale",
				name = _("Loan interest"),
				tooltip = _("Factor for the loan interest"),
				values = { _("25%"), _("50%"), _("100%"), _("200%"), _("400%"), },
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "advancedOptions.vehiclePurchaseCostScale",
				name = _("Investments vehicles"),
				tooltip = _("Factor for the buying costs of vehicles"),
				values = { _("50%"), _("75%"), _("100%"), _("125%"), _("150%"),},
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "advancedOptions.infrastructurePurchaseCostScale",
				name = _("Investments infrastructure"),
				tooltip = _("Factor for the costs of terrain modification and infrastructure construction"),
				values = { _("50%"), _("75%"), _("100%"), _("125%"), _("150%"),},
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "advancedOptions.infrastructureMaintenanceScale",
				name = _("Maintenance infrastructure"),
				tooltip = _("Factor for the maintenance costs of tracks, roads, depots and stations"),
				values = { _("50%"), _("75%"), _("100%"), _("125%"), _("150%"),},
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "advancedOptions.vehicleMaintenanceScale",
				name = _("Maintenance vehicles"),
				tooltip = _("Factor for the maintenance costs of vehicles"),
				values = { _("50%"), _("75%"), _("100%"), _("125%"), _("150%"),},
				uiType = "SLIDER",
				defaultIndex = 2,
			},
			{
				key = "economy.industryDevelopment.closureProbability",
				name = _("Industry closure frequency"),
				tooltip = _("Frequency of industry closures due to lack use"),
				values = { _("Never"), _("Rarely"), _("Sometimes"), _("Often"), _("Very often"),},
				uiType = "COMBOBOX",
				defaultIndex = 1,
			},
			{
				key = "economy.townDevelopment.cargoNeedsPerTown",
				name = _("Towns cargo needs"),
				tooltip = _("Maximum number of cargo needs per town"),
				values = { _("2 cargo types"), _("up to 4 cargo types"), _("up to 6 cargo types"), },
				uiType = "COMBOBOX",
				defaultIndex = 1,
			},
			{
				key = "advancedOptions.publicTransportDestinationsSensitivityScale",
				name = _("Public transport"),
				tooltip = _("Influence of reachable destinations by public transport on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
			{
				key = "advancedOptions.privateTransportDestinationsSensitivityScale",
				name = _("Private transport"),
				tooltip = _("Influence of reachable destinations by private transport on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
			{
				key = "advancedOptions.cargoSupplySensitivityScale",
				name = _("Cargo supply"),
				tooltip = _("Influence of cargo supply rating on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
			{
				key = "advancedOptions.emissionSensitivityScale",
				name = _("Emission"),
				tooltip = _("Influence of emission around town buildings on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
			{
				key = "advancedOptions.trafficSpeedSensitivityScale",
				name = _("Traffic congestion"),
				tooltip = _("Influence of traffic slowdowns on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
			{
				key = "advancedOptions.stationOverflowSensitivityScale",
				name = _("Overcrowded stations"),
				tooltip = _("Influence of overcrowded stations on town growth"),
				values = getSensitivityScalePerGen()[getGen()],
				uiType = "SLIDER",
				defaultIndex = getDefaultIndex(getSensitivityScalePerGen()[getGen()], _("100%")),
			},
		},
	},
	categories = {
		{ key = "climate", name = _("Climate") },
		{ key = "vehicles", name = _("Vehicles") },
		{ key = "nameList", name = _("Town names") },
		{ key = "environment", name = _("Environment") },
		{ key = "difficulty", name = _("Difficulty") },
	},
	options = {
		climate = { { "temperate", _("Temperate") }, { "dry", _("Dry") }, { "tropical", _("Tropical") } },
		vehicles = getVehiclesPerGen()[getGen()],
		nameList = {
			{ "europe", _("European") },
			{ "england", _("English") },
			{ "france", _("French") },
			{ "germany", _("German") },
			{ "italy", _("Italian") },
			{ "korea", _("Korean") },
			{ "netherlands", _("Dutch") },
			{ "norway", _("Norwegian") },
			{ "russia", _("Russian") },
			{ "spain", _("Spanish") },
			{ "sweden", _("Swedish") },
			{ "usa", _("American") },
			{ "asia", _("Asian") }
		},
		environment = { { "temperate", _("Temperate") }, { "dry", _("Dry") }, { "tropical", _("Tropical") } },
		difficulty = { { "easy", pGetText("difficulty", "Easy") }, { "medium", pGetText("difficulty", "Medium") }, { "hard", pGetText("difficulty", "Hard") }, { "very hard", pGetText("difficulty", "Very hard") } },
	},
	runFn = function (settings, allModParams)
		local baseNonUsa = function (fileName, data)
			return ffu.package.base(fileName, data) and not string.find(fileName, "/usa/")
		end
		
		local baseNonAsia = function (fileName, data)
			return ffu.package.base(fileName, data) and not string.find(fileName, "/asia/")
		end

		local baseNonTropical = function (fileName, data)
			return ffu.package.base(fileName, data) and not string.find(fileName, "/tropical/")
		end
		
		local baseTemperate = function (fileName, data)
			return ffu.package.base(fileName, data) and not string.find(fileName, "/temperate/")
		end

		local baseUsa = function (fileName, data)
			return ffu.package.base(fileName, data) and string.find(fileName, "/usa/")
		end
		
		local baseTropical = function (fileName, data)
			return ffu.package.base(fileName, data) and string.find(fileName, "/tropical/")
		end

		local baseAsia = function (fileName, data)
			return ffu.package.base(fileName, data) and string.find(fileName, "/asia/")
		end

		local baseOrMod = ffu.util.combineOr({ffu.util.combineAnd({ baseNonTropical, baseNonUsa, baseNonAsia }), ffu.package.mod })
		local usaOrMod = ffu.util.combineOr({ baseUsa, ffu.package.mod })
		local tropicalOrMod = ffu.util.combineOr({ baseTropical, ffu.package.mod })
		local asiaOrMod = ffu.util.combineOr({ baseAsia, ffu.package.mod })

		local modParams = allModParams[""]		-- getCurrentModId() -> nil

		local closureFreq = { 0, 1, 2, 3, 4 }
		game.config.economy.industryDevelopment.closureProbability = closureFreq[modParams["economy.industryDevelopment.closureProbability"] + 1]

		local industryFreq = { .4, .6, .8, 1.0 }
		local startIndustriesIdx = modParams["locations.industry.maxNumberPerArea"]
		local targetNumberPerAreaIdx = modParams["locations.industry.targetMaxNumberPerArea"]

		game.config.locations.industry.maxNumberPerArea =
				game.config.locations.industry.maxNumberPerArea * industryFreq[startIndustriesIdx + 1]

		if targetNumberPerAreaIdx > 0 then
			game.config.locations.industry.targetMaxNumberPerArea =
					game.config.locations.industry.targetMaxNumberPerArea * industryFreq[targetNumberPerAreaIdx]

			game.config.economy.industryDevelopment.spawnIndustries = true
		else
			game.config.locations.industry.targetMaxNumberPerArea = game.config.locations.industry.maxNumberPerArea

			game.config.economy.industryDevelopment.spawnIndustries = false
		end
		
		local cargoNeeds = { 2, 4, 6 }
		game.config.economy.townDevelopment.cargoNeedsPerTown = cargoNeeds[modParams["economy.townDevelopment.cargoNeedsPerTown"] + 1]

		local maximumLoanScale = { .5, .75, 1.0, 1.25, 1.5 }
		game.config.advancedOptions.maximumLoanScale = maximumLoanScale[modParams["advancedOptions.maximumLoanScale"] + 1]

		local loanInterestScale = { .25, .5, 1.0, 2.0, 4.0 }
		game.config.advancedOptions.loanInterestScale = loanInterestScale[modParams["advancedOptions.loanInterestScale"] + 1]

		local purchaseCostScale = { .5, .75, 1.0, 1.25, 1.5 }
		game.config.costs.terrainLower = game.config.costs.terrainLower * purchaseCostScale[modParams["advancedOptions.infrastructurePurchaseCostScale"] + 1]
		game.config.costs.terrainRaise = game.config.costs.terrainRaise * purchaseCostScale[modParams["advancedOptions.infrastructurePurchaseCostScale"] + 1]

		local sensitivityScale = {.0, .25, .5, .75, 1.0, 1.25, 1.5, 1.75, 2.0}
		game.config.advancedOptions.publicTransportDestinationsSensitivityScale = sensitivityScale[modParams["advancedOptions.publicTransportDestinationsSensitivityScale"] + 1]
		game.config.advancedOptions.privateTransportDestinationsSensitivityScale = sensitivityScale[modParams["advancedOptions.privateTransportDestinationsSensitivityScale"] + 1]
		game.config.advancedOptions.cargoSupplySensitivityScale = sensitivityScale[modParams["advancedOptions.cargoSupplySensitivityScale"] + 1]

		game.config.advancedOptions.emissionSensitivityScale = sensitivityScale[modParams["advancedOptions.emissionSensitivityScale"] + 1]
		game.config.advancedOptions.trafficSpeedSensitivityScale = sensitivityScale[modParams["advancedOptions.trafficSpeedSensitivityScale"] + 1]
		game.config.advancedOptions.stationOverflowSensitivityScale = sensitivityScale[modParams["advancedOptions.stationOverflowSensitivityScale"] + 1]


		if settings.climate == "dry" then
			game.config.climate = "dry.clima.lua"
		elseif settings.climate == "tropical" then
			game.config.climate = "tropical.clima.lua"
		end
		
		
		addFileFilter("model/car",  function (fileName, data)
			if fileName == "res/models/model/placeholders/missing_car.mdl" then return false end
			return true
		end)
		addFileFilter("model/person",  function (fileName, data)
			if fileName == "res/models/model/placeholders/missing_person.mdl" then return false end
			return true
		end)
		addFileFilter("construction",  function (fileName, data)
			if fileName == "res/construction/placeholders/generic.con" then return false end
			return true
		end)
		addFileFilter("model/vehicle",  function (fileName, data)
			if fileName == "res/models/model/placeholders/missing_road_vehicle.mdl" then return false end
			if fileName == "res/models/model/placeholders/missing_tram.mdl" then return false end
			if fileName == "res/models/model/placeholders/missing_air_vehicle.mdl" then return false end
			if fileName == "res/models/model/placeholders/missing_water_vehicle.mdl" then return false end
			if fileName == "res/models/model/placeholders/missing_rail_vehicle.mdl" then return false end
			return true
		end)
		addFileFilter("model/animal", function (fileName, data)
			if fileName == "res/models/model/placeholders/missing_animal.mdl" then return false end
			return true
		end)

		if settings.vehicles == "europe" then
			addFileFilter("model/vehicle",  function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/bus/usa/schneider_pb2.mdl"] = true,
					["res/models/model/vehicle/bus/usa/schneider_pb2_v2.mdl"] = true,
					["res/models/model/vehicle/bus/usa/wright_streetcar_rtv.mdl"] = true,
					["res/models/model/vehicle/bus/usa/wright_streetcar_rtv_v2.mdl"] = true,
					["res/models/model/vehicle/bus/asia/gaggenau_c40.mdl"] = true,
					["res/models/model/vehicle/bus/asia/gaggenau_c40_v2.mdl"] = true,
					["res/models/model/vehicle/bus/asia/bk_670.mdl"] = true,
					["res/models/model/vehicle/bus/asia/bk_670_v2.mdl"] = true,
					["res/models/model/vehicle/bus/asia/maz_103.mdl"] = true,
					["res/models/model/vehicle/bus/asia/maz_103_v2.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t_v2.mdl"] = true,
					["res/models/model/vehicle/tram/asia/lvs_86.mdl"] = true,
					["res/models/model/vehicle/tram/asia/lvs_86_v2.mdl"] = true,
					["res/models/model/vehicle/tram/asia/vityaz_m.mdl"] = true,
					["res/models/model/vehicle/tram/asia/vityaz_m_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_stake.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_stake_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tipper_v2.mdl"] = true,
					
					
				}
				
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end

				local notIncludedVehicles = {
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_stake.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_tipper.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_universal.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_tanker.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/tram/asia/toyama_8000.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/asia/maz_103_bs.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/usa/gm_fishbowl_wgl.mdl"] = false,
				}
				
				if notIncludedVehicles[fileName] ~= nil then return notIncludedVehicles[fileName] end

				if baseOrMod(fileName, data) then return true end
				
				return false
			end)
			
			addFileFilter("model/car",  function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/car/ford_model_t_v2.mdl"] = true,
					["res/models/model/vehicle/car/citroen_hp5_typ_c_v2.mdl"] = true,
					["res/models/model/vehicle/car/ford_fordor_1934_v2.mdl"] = true,
					["res/models/model/vehicle/car/avant_v2.mdl"] = true,
					["res/models/model/vehicle/car/beetle_1948_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_type_2_t1_v2.mdl"] = true,
					["res/models/model/vehicle/car/trabant_v2.mdl"] = true,
					["res/models/model/vehicle/car/renault_4_f4_fourgonnette_v2.mdl"] = true,
					["res/models/model/vehicle/car/nissan_datsun_240z_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_golf_1_v2.mdl"] = true,
					["res/models/model/vehicle/car/corolla_v2.mdl"] = true,
					["res/models/model/vehicle/car/opel_kadett_e_caravan_v2.mdl"] = true,
					["res/models/model/vehicle/car/opel_limo_v2.mdl"] = true,
					["res/models/model/vehicle/car/subaru_legacy_kombi_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_touran_v2.mdl"] = true,
					["res/models/model/vehicle/car/toyota_mirai_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_01_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_02_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_03_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_04_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_05_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_06_v2.mdl"] = true,
				}
					
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end
			
				if ffu.package.mod(fileName, data) then return true end

				return false
			end)
			
			addFileFilter("multipleUnit", baseOrMod)
		elseif settings.vehicles == "usa" then
			addFileFilter("model/vehicle", function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/bus/asia/maz_103.mdl"] = true,
					["res/models/model/vehicle/bus/asia/maz_103_v2.mdl"] = true,
					["res/models/model/vehicle/bus/man_sl_192.mdl"] = true,
					["res/models/model/vehicle/bus/man_sl_192_v2.mdl"] = true,
					["res/models/model/vehicle/bus/volvo_5000.mdl"] = true,
					["res/models/model/vehicle/bus/volvo_5000_v2.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t_v2.mdl"] = true,
					["res/models/model/vehicle/tram/be5_6.mdl"] = true,
					["res/models/model/vehicle/tram/be5_6_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/amo_f15_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/amo_f15_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/amo_f15_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/amo_f15_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/isuzu_elf_tld20_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/asia/gaz_3307_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_universal.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_stake.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_stake_v2.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/asia/faw_jiefang_j6p_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_stake.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_stake_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/bus/ecitaro.mdl"] = true,
					["res/models/model/vehicle/bus/ecitaro_v2.mdl"] = true,
					["res/models/model/vehicle/truck/urban_etruck.mdl"] = true,
					["res/models/model/vehicle/truck/urban_etruck_v2.mdl"] = true,
					["res/models/model/vehicle/tram/caf_urbos3.mdl"] = true,
					["res/models/model/vehicle/tram/caf_urbos3_v2.mdl"] = true,
					
					
					["res/models/model/vehicle/waggon/tankcar_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/stake_car_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/gondola_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/boxcar_2000.mdl"] = true,
				}
				
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end
				
				local notIncludedVehicles = {
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/bus/citroen_cityrama.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_front.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_middle1.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_middle2.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/tram/asia/toyama_8000.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/asia/maz_103_bs.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/ecitaro_lu.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_front.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle1.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle2.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle3.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle4.mdl"] = false,			}
				
				if notIncludedVehicles[fileName] ~= nil then return notIncludedVehicles[fileName] end

				if usaOrMod(fileName, data) then return true end
	
				if string.starts(fileName, "res/models/model/vehicle/plane/") then return true end
				if string.starts(fileName, "res/models/model/vehicle/ship/") then return true end
			
			
				return false
			end)
			
			addFileFilter("model/car",  function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/car/ford_model_t_v2.mdl"] = true,
					["res/models/model/vehicle/car/citroen_hp5_typ_c_v2.mdl"] = true,
					["res/models/model/vehicle/car/ford_fordor_1934_v2.mdl"] = true,
					["res/models/model/vehicle/car/chevrolet_master_deluxe_v2.mdl"] = true,
					["res/models/model/vehicle/car/ford_f_series_pickup_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_type_2_t1_v2.mdl"] = true,
					["res/models/model/vehicle/car/cadillac_s62_deville_v2.mdl"] = true,
					["res/models/model/vehicle/car/renault_4_f4_fourgonnette_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_golf_1_v2.mdl"] = true,
					["res/models/model/vehicle/car/pickup_1978_v2.mdl"] = true,
					["res/models/model/vehicle/car/corolla_v2.mdl"] = true,
					["res/models/model/vehicle/car/lincoln_town_car_v2.mdl"] = true,
					["res/models/model/vehicle/car/subaru_legacy_kombi_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_touran_v2.mdl"] = true,
					["res/models/model/vehicle/car/toyota_mirai_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_01_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_02_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_03_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_04_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_05_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_06_v2.mdl"] = true,
				}
					
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end
			
				if ffu.package.mod(fileName, data) then return true end

				return false
			end)
			
			addFileFilter("multipleUnit", function (fileName, data)
				
				if fileName == "dlcs/urbangames_deluxe_pack_1/res/config/multiple_unit/hst_125.lua" then return false end
				if fileName == "dlcs/urbangames_preorder_pack_1/res/config/multiple_unit/tgv_pse.lua" then return false end
			
				if usaOrMod(fileName, data) then return true end

				return false
			end)
		elseif settings.vehicles == "asia" then
			addFileFilter("model/vehicle", function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/bus/man_sl_192.mdl"] = true,
					["res/models/model/vehicle/bus/man_sl_192_v2.mdl"] = true,
					["res/models/model/vehicle/bus/volvo_5000.mdl"] = true,
					["res/models/model/vehicle/bus/volvo_5000_v2.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t.mdl"] = true,
					["res/models/model/vehicle/tram/usa/skoda_10t_v2.mdl"] = true,
					["res/models/model/vehicle/tram/be5_6.mdl"] = true,
					["res/models/model/vehicle/tram/be5_6_v2.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_stake.mdl"] = true,
					["res/models/model/vehicle/truck/benz1912_lkw_stake_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/opel_blitz_1930_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_tipper.mdl"] = true,
					["res/models/model/vehicle/truck/man_19_304_1970_tipper_v2.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons_universal_v2.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons_stake.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons_stake_v2.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons_tanker.mdl"] = true,
					["res/models/model/vehicle/truck/40_tons_tanker_v2.mdl"] = true,
					["res/models/model/vehicle/bus/ecitaro.mdl"] = true,
					["res/models/model/vehicle/bus/ecitaro_v2.mdl"] = true,
					["res/models/model/vehicle/truck/urban_etruck.mdl"] = true,
					["res/models/model/vehicle/truck/urban_etruck_v2.mdl"] = true,
					["res/models/model/vehicle/tram/caf_urbos3.mdl"] = true,
					["res/models/model/vehicle/tram/caf_urbos3_v2.mdl"] = true,
					
					["res/models/model/vehicle/waggon/tankcar_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/stake_car_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/gondola_2000.mdl"] = true,
					["res/models/model/vehicle/waggon/boxcar_2000.mdl"] = true,
				
				
				}
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end
				
				local notIncludedVehicles = {
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_stake.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_tipper.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_universal.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/truck/usa/kenworth_k100e_tanker.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/bus/citroen_cityrama.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_front.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_middle1.mdl"] = false,
					["dlcs/urbangames_deluxe_pack_1/res/models/model/vehicle/train/hst_125_middle2.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/ecitaro_lu.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/bus/usa/gm_fishbowl_wgl.mdl"] = false,
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_front.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle1.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle2.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle3.mdl"] = false,	
					["dlcs/urbangames_preorder_pack_1/res/models/model/vehicle/train/tgv_pse_middle4.mdl"] = false,	
				}
				
				if notIncludedVehicles[fileName] ~= nil then return notIncludedVehicles[fileName] end

				if asiaOrMod(fileName, data) then return true end
	
				if string.starts(fileName, "res/models/model/vehicle/plane/") then return true end
				if string.starts(fileName, "res/models/model/vehicle/ship/") then return true end
				
			
				return false
			end)
			
			addFileFilter("model/car",  function (fileName, data)
				local extraVehicles = {
					["res/models/model/vehicle/car/ford_model_t_v2.mdl"] = true,
					["res/models/model/vehicle/car/citroen_hp5_typ_c_v2.mdl"] = true,
					["res/models/model/vehicle/car/ford_fordor_1934_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_type_2_t1_v2.mdl"] = true,
					["res/models/model/vehicle/car/renault_4_f4_fourgonnette_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_golf_1_v2.mdl"] = true,
					["res/models/model/vehicle/car/corolla_v2.mdl"] = true,
					["res/models/model/vehicle/car/subaru_legacy_kombi_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_touran_v2.mdl"] = true,
					["res/models/model/vehicle/car/toyota_mirai_v2.mdl"] = true,
					["res/models/model/vehicle/car/kim_10_50_v2.mdl"] = true,
					["res/models/model/vehicle/car/tatra_600_v2.mdl"] = true,
					["res/models/model/vehicle/car/gaz_22_wolga_v2.mdl"] = true,
					["res/models/model/vehicle/car/lada_riva_v2.mdl"] = true,
					["res/models/model/vehicle/car/vw_santana_1985_v2.mdl"] = true,
					["res/models/model/vehicle/car/haval_h6_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_01_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_02_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_03_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_04_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_05_v2.mdl"] = true,
					["res/models/model/vehicle/car/coach_06_v2.mdl"] = true,
				}
					
				if extraVehicles[fileName] ~= nil then return extraVehicles[fileName] end
			
				if ffu.package.mod(fileName, data) then return true end

				return false
			end)
			
			addFileFilter("multipleUnit", function (fileName, data)
				
				if fileName == "dlcs/urbangames_deluxe_pack_1/res/config/multiple_unit/hst_125.lua" then return false end
				if fileName == "dlcs/urbangames_preorder_pack_1/res/config/multiple_unit/tgv_pse.lua" then return false end
			
				if asiaOrMod(fileName, data) then return true end

				return false
			end)


			
	
		end

		local filterAndKeepShared = function (fileName, data)
			if string.find(fileName, "/shared/") then return true end
			if settings.climate == "dry" and usaOrMod(fileName, data) then return true
			elseif settings.climate == "tropical" and tropicalOrMod(fileName, data) then return true
			elseif settings.climate ~= "dry" and settings.climate ~= "tropical"
				and baseOrMod(fileName, data) then return true end
	
			return false
		end
		addFileFilter("terrainMaterial", filterAndKeepShared)
		addFileFilter("grass", filterAndKeepShared)
		
		if settings.climate == "dry" then
			addFileFilter("autoGroundTex", function (fileName, data)
				return usaOrMod(fileName, data)
			end)
		elseif settings.climate == "tropical" then
			addFileFilter("autoGroundTex", function (fileName, data)
				return tropicalOrMod(fileName, data)
			end)
		else
			addFileFilter("autoGroundTex", function (fileName, data)
				return baseOrMod(fileName, data)
			end)
		end

		local cfg = game.config.nameList
		cfg.folder = settings.nameList

		local function reorderAsset(keyword, offset)
			return function(fileName, data)
				if not data.metadata.categoryList then return true end
				local cat = data.metadata.categoryList.categories
				if cat then
					for k, v in pairs(cat) do
						if v == keyword then
							data.metadata.order.value = data.metadata.order.value + offset
						end
					end
				end
				return true
			end
		end

		local defaultPreprocessFn = function(modules, change)
			if change.added then
				modules[change.slotId] = change.module
			else
				modules[change.slotId] = nil
			end
			return modules
		end
		addModifier("loadConstruction", function(fileName, data)
			if data.preProcessFn == nil then
				data.preProcessFn = defaultPreprocessFn
			end
			
			return data
		end)
		if settings.climate == "temperate" then
			addFileFilter("model/tree", baseOrMod)
			addFileFilter("model/rock", reorderAsset("temperate.clima.lua", -100))
			
			addFileFilter("construction", function (fileName, data)
				if fileName == "res/construction/asset/default_brush_tree_palms.con" then return false end
				if fileName == "res/construction/asset/default_brush_tree_cacti.con" then return false end
				
				if string.find(fileName, "construction/asset/tropical/") 
					or string.find(fileName, "construction/asset/desert/") then 
					return false
				end
				
				return true
			end)
		elseif settings.climate == "dry" then
			addFileFilter("model/tree", usaOrMod)
			addFileFilter("model/rock", reorderAsset("dry.clima.lua", -100))
						
			addFileFilter("construction", function (fileName, data)
				if fileName == "res/construction/asset/default_brush_tree_palms.con" then return false end
				
				if string.find(fileName, "construction/asset/tropical/") 
					or string.find(fileName, "construction/asset/temperate/") then 
					return false
				end
				
				return true
			end)
		elseif settings.climate == "tropical" then
			addFileFilter("model/tree", tropicalOrMod)
			addFileFilter("model/rock", reorderAsset("tropical.clima.lua", -100))
			
			addFileFilter("construction", function (fileName, data)
				if fileName == "res/construction/asset/default_brush_tree_cacti.con" then return false end
				
				if string.find(fileName, "construction/asset/desert/") 
					or string.find(fileName, "construction/asset/temperate/") then 
					return false
				end
				
				return true
			end)
		end

		if settings.vehicles == "usa" then
			addFileFilter("trafficLight", usaOrMod)
		else
			addFileFilter("trafficLight", baseOrMod)
		end
		
		if settings.environment == "dry" then
			addFileFilter("railroadCrossing", function (fileName, data)
				if fileName == "res/config/railroad_crossing/era_a_us_crossing.lua" 
					or fileName == "res/config/railroad_crossing/era_b_us_crossing.lua" 
					or fileName == "res/config/railroad_crossing/era_c_us_crossing.lua" then return true end
				
				if ffu.package.mod(fileName, data) then return true end
				
				return false
			end)
		elseif settings.environment == "tropical" then
			addFileFilter("railroadCrossing", function (fileName, data)
				if fileName == "res/config/railroad_crossing/era_a_ru_crossing.lua" 
					or fileName == "res/config/railroad_crossing/era_b_ru_crossing.lua"
					or fileName == "res/config/railroad_crossing/era_c_ru_crossing.lua" then return true end
				
				if ffu.package.mod(fileName, data) then return true end
				
				return false
			end)
		else
			addFileFilter("railroadCrossing", function (fileName, data)
				if fileName == "res/config/railroad_crossing/era_a_eu_crossing.lua" 
					or fileName == "res/config/railroad_crossing/era_b_eu_crossing.lua"
					or fileName == "res/config/railroad_crossing/era_c_eu_crossing.lua" then return true end
				
				if ffu.package.mod(fileName, data) then return true end
				
				return  false
			end)
		end

		addFileFilter("street", function (fileName, data)
			if string.find(fileName, "res/config/street/airport/")
			   or string.find(fileName, "res/config/street/water/")
			   or string.find(fileName, "res/config/street/street_station/")
			   or string.find(fileName, "res/config/street/street_depot/") then return false
			end

			if data.upgrade then return false end

			return true
		end)

		if settings.difficulty == "medium" then
			game.config.difficulty = "MEDIUM"
		elseif settings.difficulty == "hard" then
			game.config.difficulty = "HARD"
		elseif settings.difficulty == "very hard" then
			game.config.difficulty = "VERY HARD"
		end

		if settings.environment == "dry" then
			game.config.environment = "desert.lua"
		elseif settings.environment == "tropical" then 
			game.config.environment = "tropical.lua"
		end
		
		addModifier("loadModel", metadatautil.addEmissionMetadata)
		
		addModifier("loadModel", function(fileName, data)
			local tv = data.metadata.transportVehicle
			
			if tv then
				if tv.seats and not data.metadata.seatProvider then
					local sp = { }
					sp.seats = tv.seats
					if tv.carrier == "AIR" then sp.drivingLicense = "AIR" end
					if tv.carrier == "RAIL" then sp.drivingLicense = "RAIL" end
					if tv.carrier == "ROAD" then sp.drivingLicense = "BUS" end
					if tv.carrier == "TRAM" then sp.drivingLicense = "TRAM" end
					if tv.carrier == "WATER" then sp.drivingLicense = "WATER" end
					sp.crewModels = tv.crewModels
					
					data.metadata.seatProvider = sp

					for k,v in pairs(data.metadata.seatProvider.seats) do
						if v.animation == nil then
							v.animation = v.standing and "idle" or "sitting"
						end
					end
				end
			end
			
			return data
		end)
		
		addModifier("loadModel", function(fileName, data)
			if data.collider and data.collider.params and data.collider.params.center then
				local c = data.collider.params.center
				data.collider.transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, c[1], c[2], c[3], 1 }
			end
			
			return data
		end)
		
		addModifier("loadGroundTex", function(fileName, data)
			local tropicalMap = {
				["dirt.lua"] = "tropical/dirt.lua",
				["rock.lua"] = "tropical/rock.lua",
				["scree.lua"] = "tropical/scree.lua",
				["grass_light_green.lua"] = "tropical/grass_light_green.lua",
				["grass_brown.lua"] = "tropical/grass_brown.lua",
				["grass_green.lua"] = "tropical/grass_green.lua",
				["grass_gravel.lua"] = "tropical/grass_gravel.lua",
				["gravel_01.lua"] = "tropical/gravel_01.lua",
			}
			local usaMap = {
				["dirt.lua"] = "usa/dirt.lua",
				["rock.lua"] = "usa/rock.lua",
				["scree.lua"] = "usa/scree.lua",
				["tropical/scree.lua"] = "usa/scree.lua",
				["grass_light_green.lua"] = "shared/grass_cutted_01.lua",
				["grass_brown.lua"] = "usa/soil_sand_03.lua",
				["grass_green.lua"] = "usa/sand_red_01.lua",
				["grass_gravel.lua"] = "usa/grass_gravel.lua",
				["gravel_01.lua"] = "usa/gravel_01.lua",
			}
			local map = {
			
			}
		
			local replaceMateirals = function(mimap)
				if settings.climate == "dry" then
					for k, v in pairs(mimap) do
						if usaMap[v] ~= nil then mimap[k] = usaMap[v] end
						if map[v] ~= nil then mimap[k] = map[v] end
					end
				elseif settings.climate == "tropical" then
					for k, v in pairs(mimap) do
						if tropicalMap[v] ~= nil then mimap[k] = tropicalMap[v] end
						if map[v] ~= nil then mimap[k] = map[v] end
					end
				end
			end
				
			if data.indexMap ~= nil then
				replaceMateirals(data.indexMap)
			else
				replaceMateirals(data.materialIndexMap)
			end
			
			return data
		end)

		addModifier("loadStreet", function(fileName, data)
			local numLanes = data.numLanes

			if numLanes and not data.laneConfig then
				local numLanesPlusSidewalks = numLanes + 2
				local laneConfig = {}
				for i=1,numLanesPlusSidewalks do
					laneConfig[i] = { forward = i > numLanesPlusSidewalks / 2 }
				end
				data.laneConfig = laneConfig
			end
			
			if data.assets ~= nil then
				local newTable = {}
				for k,v in pairs(data.assets) do
					k = tostring(k)
					newTable[k] = v
				end
				data.assets = newTable
			end


			return data
		end)
		
		addModifier("loadBridge", function(fileName, data)
			if data.assetsToReplace ~= nil then
				local newTable = {}
				for k,v in pairs(data.assetsToReplace) do
					k = tostring(k)
					newTable[k] = v
				end
				data.assetsToReplace = newTable
			end
			return data
		end)

		local function modelCostCallback(fileName, data)

			local scaleValues = { .5, .75, 1.0, 1.25, 1.5 }

			local costScale = scaleValues[modParams["advancedOptions.vehiclePurchaseCostScale"] + 1]
			local purchaseCost = data.metadata.cost
			if purchaseCost then
				if purchaseCost.price == -1 then
					purchaseCost.priceScale = (purchaseCost.priceScale or 1.0) * costScale
				elseif purchaseCost.price > 0 then
					purchaseCost.price = purchaseCost.price * costScale
				end
			end

			local maintenanceScale = scaleValues[modParams["advancedOptions.vehicleMaintenanceScale"] + 1]
			local maintenance = data.metadata.maintenance
			if maintenance and maintenance.runningCosts ~= nil then
				if maintenance.runningCosts < 0 then
					maintenance.runningCostScale = (maintenance.runningCostScale or 1.0) * maintenanceScale
				elseif maintenance.runningCosts > 0 then
					maintenance.runningCosts = maintenance.runningCosts * maintenanceScale
				end
			end
		
			return data
		end

		local function moduleCostCallback(filename, data)
			local scaleValues = { .5, .75, 1.0, 1.25, 1.5 }
			
			local cost = data.cost
			if cost ~= nil then

				local maintenanceScale = scaleValues[modParams["advancedOptions.infrastructureMaintenanceScale"] + 1]
				if (cost.maintenanceCost == nil or cost.maintenanceCost == 0) then
					cost.maintenanceCost = (cost.price / (10 * 12)) * maintenanceScale
				elseif cost.maintenanceCost ~= nil and cost.maintenanceCost > 0 then
					cost.maintenanceCost = cost.maintenanceCost * maintenanceScale
				end

				local costScale = scaleValues[modParams["advancedOptions.infrastructurePurchaseCostScale"] + 1]
				if cost.price ~= nil and cost.price > 0 then
					cost.price = cost.price * costScale
				end

				if cost.bulldozeCost ~= nil and cost.bulldozeCost > 0 then
					cost.bulldozeCost = cost.bulldozeCost * costScale
				end
			end
			return data
		end

		local function costCallback(fileName, data)
			local scaleValues = { .5, .75, 1.0, 1.25, 1.5 }
			if data.cost ~= nil and data.cost > 0 then
				data.cost = data.cost * scaleValues[modParams["advancedOptions.infrastructurePurchaseCostScale"] + 1]
			end
			return data
		end

		local function constructionCostCallback(fileName, data)
			local scaleValues = { .5, .75, 1.0, 1.25, 1.5 }
			local fn = data.updateFn

			data.updateFn = function(params)
				local result = fn(params)
				
				local maintenanceScale = scaleValues[modParams["advancedOptions.infrastructureMaintenanceScale"] + 1]
				local maintenanceCost = result.maintenanceCost
				if (maintenanceCost == nil or maintenanceCost == 0)  and result.cost ~= nil then
					maintenanceCost = (result.cost / (10 * 12)) * maintenanceScale
				elseif maintenanceCost ~= nil and maintenanceCost > 0 then
					maintenanceCost = maintenanceCost * maintenanceScale
				end
				
				local costScale = scaleValues[modParams["advancedOptions.infrastructurePurchaseCostScale"] + 1]
				local cost = result.cost
				if cost ~= nil and cost > 0 then
					cost = cost * costScale
				end
				
				local bulldozeCost = result.bulldozeCost
				if bulldozeCost ~= nil and bulldozeCost > 0 then
					bulldozeCost = bulldozeCost * costScale
				end
				
				return result
			end
			return data
		end
		
		addModifier("loadModel", modelCostCallback)
		addModifier("loadModule", moduleCostCallback)
		addModifier("loadStreet", costCallback)
		addModifier("loadTrack", costCallback)
		addModifier("loadBridge", costCallback)
		addModifier("loadTunnel", costCallback)
		addModifier("loadRailroadCrossing", costCallback)
		addModifier("loadConstruction", constructionCostCallback)

	end,
	
	postRunFn = function(settings, params)
		local tracks = api.res.trackTypeRep.getAll()
		
		for __, trackName in pairs(tracks) do
			local mod = api.type.ModuleDesc.new()
			
			local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackName))
			
			if trackName ~= "standard.lua" and trackName ~= "high_speed.lua" then 
				for __, catenary in pairs({false, true}) do
					mod.fileName = "trainstation_" .. tostring(trackName) .. (catenary and "catenary" or "")
					
					mod.availability.yearFrom = track.yearFrom
					mod.availability.yearTo = track.yearTo
					mod.cost.price = math.round(track.cost / 75 * 18000)
					
					mod.description.name = track.name .. (catenary and _(" with catenary") or "")
					mod.description.description = track.desc .. (catenary and _(" (with catenary)") or "")
					mod.description.icon = track.icon
					if mod.description.icon ~= "" then
						mod.description.icon = string.gsub(mod.description.icon, ".tga", "")
						mod.description.icon = mod.description.icon .. "_module" .. (catenary and "_catenary" or "") .. ".tga"
					end
					
					mod.type = "track"
					mod.order.value = 0 + 10 * (catenary and 1 or 0)
					mod.metadata = {
						track = true,
					}
					mod.category.categories = { "tracks", }
					
					mod.updateScript.fileName = "construction/station/rail/modular_station/trackmodule.updateFn"
					mod.updateScript.params = {
						trackType = trackName,
						catenary = catenary
					}
					mod.getModelsScript.fileName = "construction/station/rail/modular_station/trackmodule.getModelsFn"
					mod.getModelsScript.params = {
						trackType = trackName,
						catenary = catenary
					}
					
					api.res.moduleRep.add(mod.fileName, mod, true)
				end
			end
		end
	end
}
end
