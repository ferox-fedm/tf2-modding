local modifier = require "mission.modifier"

local t = {
	missionstart = 1865,
	missionend = 1875,

	medalCockpitTime = 2,
	medalBigfootZone = { pos = { 937, -772 }, radius = 40 },
	medalDriveZone = { pos = { 1140, 7 }, radius = 40 },
	busStationForestZone = { pos = { 1357, 587 }, radius = 20},
	busStationMineZone = { pos = { 1042, 713 }, radius = 30},
	streetDepotMineZone = { pos = { 1279, 601 }, radius = 30},
	railStationMineZone = { pos = { 940, 556 }, radius = 20},
	railStationSilverProcessingZone = { pos = { 459, -1258 }, radius = 30},
	railStationCarsonCityZone = { pos = { 62, -1187 }, radius = 30},
	railStationRenoZone = { pos = { -502, 1582 }, radius = 30},
	busStationCarsonCityZone1 = { pos = { 302, -1117 }, radius = 30},
	busStationCarsonCityZone2 = { pos = { 200, -1284 }, radius = 30},
	busStationCarsonCityZone3 = { pos = { 234, -1557 }, radius = 30},
	trainDepotMineZone = { pos = { 1018, 20 }, radius = 30},
	mineZone = { pos = { 880, 630 }, radius = 10 },
	mineWoodZone = { pos = { 950, 750 }, radius = 10 },

	snapNode2a = 5722,
	snapNode2c = 5826,
	snapNode3a = 8223,
	snapNode3b_prop1 = { 7970, 8034},
	snapNode3b_prop1_node1pos = { 1447, -170 },
	snapNode3b_prop1_node2pos = { 1630, -224 },
	snapNode3b_prop2 = { 8048, 8045},
	snapNode3b_prop2_node1pos = { 1692, -247 },
	snapNode3b_prop2_node2pos = { 1665, -394 },
	snapNode3b_prop3 = { 4949, 8056},
	snapNode3b_prop3_node1pos = { 1579, -394 },
	snapNode3b_prop3_node2pos = { 1316, -499 },
	snapNode5a = { 6047, 5280 },

	buildingArea3e = {
		{  960,  221 },
		{  960,  -36 },
		{ 1048,  -47 },
		{ 1120,   72 },
		{ 1032,  225 },
	},
	buildingArea5a = {
		{  80, -1171 },
		{  107, -466  },
		{ -198,  -92  },
		{ -385,  207  },
		{ -460, 1100  },
		{ -687, 1135  },
		{ -730,  798  },
		{ -545,  275  },
		{ -416,  -64  },
		{ -317, -533  },
		{   34, -1196 },
	},

	lakepos = { -1342, -1146 },

	numberofcargowagons = 3,
	numberofpassengerwagons = 3,
	numberofpassengers = 20,
	numberofpassengerscarsoncity = 5,
	numberofhorsecarts = 3,
	woodmillconsumption = 1,

	carsonCity = 8169,
	reno = 7465,
	virginiaCity = 5055,
	silverOreMine = 5353,
	silverMineWoodDeposit = 4217,
	lakeHouse = 7287,
	silverProcessing = 11540,
	woodProcessingMill = 6110,
	busStationVirginia = 11542,
	railStationCarson = 6617,
	railStationReno = 6554,
	forestVirginia = 5706,
	forestCarson = 8255,
	truckStationCarsonCity = 8185,

	amountDeliverSilverOre2 = 40,

	modelNames = {
		trainName = "vehicle/train/usa/baldwin_six_wheels_v2.mdl",
		passengerWagonName = "vehicle/waggon/usa/pullman_1850_v2.mdl",
		cargoWagonName = "vehicle/waggon/usa/gondola_1850.mdl",
		truckName = "vehicle/truck/usa/horsewagon_1850_usa_v2.mdl",
		busName = "vehicle/bus/usa/horse_carriage_v2.mdl",
	},

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						usa = {
							["baldwin_six_wheels_v2.mdl"] = 1,
							default = modifier.util.disable,
						}
					},
					waggon = {
						usa = {
							["gondola_1850.mdl"] = modifier.util.cargotypes({ "SILVER_ORE" }),
							["pullman_1850_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
					},
					truck = modifier.util.cargotypes({ "LOGS" }),
					tram = modifier.util.disable,
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
