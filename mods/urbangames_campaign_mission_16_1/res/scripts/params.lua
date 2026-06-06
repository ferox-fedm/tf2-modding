local stringutil = require "stringutil"
local modifier = require "mission.modifier"

local missionstart = 1989
local missionend = 2009

local t = {
	millisperday = 8000,

	--400/400/400 + main station
	frankfurt = 17408,
	stuttgart = 16724,
	nuremberg = 36644,

	--200/200/200 + main station
	wuerzburg = 28064,
	mannheim = 43387,

	--200/200/200 + medium station
	fulda = 53769,
	heilbronn = 45146,
	ansbach = 45890,
	ulm = 41663,
	ingolstadt = 39902,

	--50/50/50 + small station
	sinsheim = 50962,
	crailsheim = 18603,
	badorb = 51625,
	badkissingen = 54492,
	greding = 52882,
	rohr = 52485,
	mundelsheim = 34296,
	gruibingen = 50163,

	station_frankfurt = 32448,
	station_stuttgart = 34729,
	station_nuremberg = 35555,
	station_wuerzburg = 47918,
	station_mannheim = 43539,

	station_fulda = 27508,
	station_heilbronn = 45488,
	station_ansbach = 28446,
	station_ulm = 10988,
	station_ingolstadt = 41169,

	station_sinsheim = 51528,
	station_crailsheim = 49607,
	station_badorb = 51875,
	station_badkissingen = 42863,
	station_greding = 53404,
	station_rohr = 52887,
	station_mundelsheim = 21676,
	station_gruibingen = 50373,

	goodsfactory = 33334,
	conmatplant = 34571,
	foodprocessing = 49505,
	fuelfactory = 49962,
	machinesfactory = 49472,
	toolsfactory = 49147,

	default = { pos = {0, 0, 3000} },
	bw = { pos = { -2000, -1800, 2000} },
	bayern = { pos = { 2500, -1600, 2000} },

	--1:
	public_transport = 1500,
	capacity = 900,
	rate = 120,
	credit = 100000000,

	--2:
	testice = "vehicle/train/ice1_waggon_3.mdl",
	regularice = "vehicle/train/ice1_middle1_v2.mdl",
	icetrain = "vehicle/train/ice1_front_v2.mdl",
	icecount = 8,
	icemeter = 50000,

	timedata = { 150, 110, 120, 110 },

	--3:
	trackcount = 1300,
	platformcount = 1100,

	--4:
	zone_names = { "Baden-Württemberg", "Bayern"},
	zone_names_not = { "Bayern", "Baden-Württemberg"},

	revenue = 50000000,

	zone_a = {
		{ -1420,  1400 },
		{ -5120,  1400 },
		{ -5120, -5120 },
		{  3350, -5120 },
		{     0, -2150 },
	},
	zone_b = {
		{ -1420,  1400 },
		{     0, -2150 },
		{  3350, -5120 },
		{  5120, -5120 },
		{  5120,  2400 },
	},
	zone_c = {
		{ -1420, 1400 },
		{  5120, 2400 },
		{  5120, 5120 },
		{ -5120, 5120 },
		{ -5120, 1400 },
	},
	regionalcount = 3,
	regionalpassengers = 2500,

	--5:
	railmoney = 200000000,
	roadmoney = 20000000,

	--m1:
	blumerbonus = 1000000,
	planelocator = { pos = { -2500, -600, 1500 } },

	roofcount = 98,
	sidebuildingscount = 10,

	--m2:
	towns_to_visit_count = 3,

	--m3:
	treezone = { pos = { -2900, -2600 }, radius = 60 },
	housezone = { pos = { -2900, -2800 }, radius = 40 },
	waterzone = { pos = { -2500, -3000 }, radius = 60 },
	tunnelzone = { pos = { -3060, -2400 }, radius = 130 },

	missionstart = missionstart,
	missionend = missionend,

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						["schienenbus_v2.mdl"] = 1,
						["db_v100_v2.mdl"] = 1,
						["obb_1042_v2.mdl"] = 1,
						["br_218_v2.mdl"] = 1,
						["br_185_traxx_v2.mdl"] = 1,
						["br_246_traxx_v2.mdl"] = 1,
						["ice1_front_v2.mdl"] = modifier.util.availability(missionstart, nil),
						["ice1_middle1_v2.mdl"] = modifier.util.availability(missionstart, nil),
						["ice1_middle2_v2.mdl"] = modifier.util.availability(missionstart, nil),
						["ice1_waggon_3.mdl"] = modifier.util.availability(missionstart, nil),
						["rabde_12_12_front_v2.mdl"] = 1,
						["rabde_12_12_middle1_v2.mdl"] = 1,
						["re_450_front_v2.mdl"] = 1,
						["re_450_middle1_v2.mdl"] = 1,
						["re_450_back_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["ew_ii_v2.mdl"] = 1,
						["hbi1_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES" }),
						["rungenwagen_1950.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }),
						["kesselwagen_1950_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["boxcar_2000.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES" }),
						["stake_car_2000.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }),
						["tankcar_2000.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						default = modifier.util.disable,
					},
					truck = {
						["man_19_304_1970_universal_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["man_19_304_1970_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["40_tons_universal_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["40_tons_stake_v2.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }),
						["40_tons_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						default = modifier.util.disable,
					},
					ship = {
						default = modifier.util.disable,
					},
					plane = {
						["bae_146_v2.mdl"] = modifier.util.availability(missionstart, nil),
						["boeing_757_v2.mdl"] = modifier.util.availability(missionstart, nil),
						["short_330_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

t.credit_formated = string.makeMoneyString(t.credit)
t.revenue_formated = string.makeMoneyString(t.revenue)
t.railmoney_formated = string.makeMoneyString(t.railmoney)
t.roadmoney_formated = string.makeMoneyString(t.roadmoney)
t.blumerbonus_formated = string.makeMoneyString(t.blumerbonus)

t.clarge = {
	t.frankfurt,
	t.stuttgart,
	t.nuremberg,
}

t.cmedium = {
	t.wuerzburg,
	t.mannheim,
	t.fulda,
	t.heilbronn,
	t.ansbach,
	t.ulm,
	t.ingolstadt,
}

t.csmall = {
	t.sinsheim,
	t.crailsheim,
	t.badorb,
	t.badkissingen,
	t.greding,
	t.rohr,
	t.mundelsheim,
	t.gruibingen,
}

t.cmain = {
	t.frankfurt,
	t.stuttgart,
	t.nuremberg,
	t.wuerzburg,
	t.mannheim,
}

t.cregional = {
	t.fulda,
	t.heilbronn,
	t.ansbach,
	t.ulm,
	t.ingolstadt,
}

t.cmunicipal = {
	t.sinsheim,
	t.crailsheim,
	t.badorb,
	t.badkissingen,
	t.greding,
	t.rohr,
	t.mundelsheim,
	t.gruibingen,
}

t.call = {
	t.frankfurt,
	t.stuttgart,
	t.nuremberg,
	t.wuerzburg,
	t.mannheim,
	t.fulda,
	t.heilbronn,
	t.ansbach,
	t.ulm,
	t.ingolstadt,
	t.sinsheim,
	t.crailsheim,
	t.badorb,
	t.badkissingen,
	t.greding,
	t.rohr,
	t.mundelsheim,
	t.gruibingen,
}

setmetatable(t, require "mission.params_mt")

return t
