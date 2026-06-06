local stringutil = require "stringutil"
local modifier = require "mission.modifier"

local missionstart = 1965
local missionend = 1975

local t = {
	missionstart = missionstart,
	missionend = missionend,

	palma = 25201,
	inca = 21381,
	sarenal = 25345,
	wien = 23273,
	frankfurt = 26318,
	zurich = 17407,

	airportpalma = 6215,
	airportwien = 8641,
	airportfrankfurt = 2355,
	airportzurich = 22193,

	airportdeliverlocation = 23917,
	distillery = 21791,
	hotel1 = 24531,
	hotel2 = 25686,
	hotel3 = 23573,
	foodprocessing = 3107,
	constructionmaterialsplant = 2672,
	farm = 26660,
	quarry = 22420,
	cattleranch = 19173,
	fuelfactory = 7671,
	steelmill = 1725,
	goodsfactory = 17051,
	toolsfactory = 19989,
	machinesfactory = 7577,
	chemicalplant = 18853,
	finca = 13401,
	harbor = 15171,

	frankfurt_bus_station = 6896,
	frankfurt_small_station1 = 7229,
	frankfurt_small_station2 = 7333,
	frankfurt_small_station3 = 7290,
	frankfurt_small_station4 = 7387,
	frankfurt_small_station5 = 7428,
	frankfurt_small_station6 = 7493,

	zurich_bus_station = 25053,
	zurich_small_station1 = 25768,
	zurich_small_station2 = 25922,
	zurich_small_station3 = 26266,
	zurich_small_station4 = 26441,

	wien_bus_station = 9290,
	wien_small_station1 = 22196,
	wien_small_station2 = 22204,
	wien_small_station3 = 22228,
	wien_small_station4 = 22236,
	wien_small_station5 = 22210,
	wien_small_station6 = 22244,
	wien_small_station7 = 22214,

	frankfurt_bus1 = 7503,
	frankfurt_bus2 = 7504,
	frankfurt_bus3 = 7515,
	frankfurt_bus4 = 7518,
	frankfurt_bus5 = 7520,
	frankfurt_bus6 = 7532,
	frankfurt_bus7 = 7538,
	frankfurt_bus8 = 7546,
	frankfurt_bus9 = 7550,

	zurich_bus1 = 1069,
	zurich_bus2 = 1095,
	zurich_bus3 = 1198,
	zurich_bus4 = 1302,
	zurich_bus5 = 1396,
	zurich_bus6 = 1398,
	zurich_bus7 = 1402,

	wien_bus1 = 19182,
	wien_bus2 = 19181,
	wien_bus3 = 19180,
	wien_bus4 = 19179,
	wien_bus5 = 19168,
	wien_bus6 = 19169,
	wien_bus7 = 19170,
	wien_bus8 = 19171,
	wien_bus9 = 19172,

	constructionmaterial_airport = 10,
	steel_airport = 10,

	fuel_amount = 50,
	public_cover_3 = 70,
	private_cover_3 = 400,

	public_cover = 40,
	private_cover = 400,
	max_emission = 60,

	steel_amount = 10,
	tools_amount = 10,
	plastic_amount = 10,

	goods5 = 50,
	food5 = 50,
	alcohol5 = 50,

	finca_party_people = 20,
	finca_party_alcohol = 20,

	culture_pay_months = 3,
	culture_pay_amount = 400000,
	culture_pay_amount_formated = string.makeMoneyString(400000),
	culture_emission = 60,

	inca_beach1 = { -772, -888 },
	inca_beach2 = { -576, -996 },
	palma_beach = { pos = { -2200, -2023 }, radius = 180 },
	inca_hills = { pos = { -1650, -1000 }, radius = 800 },
	sarenal_forest = { pos = { -1725, -2425 }, radius = 60 },

	sea_area = { pos = { -1600, -1600, 2500 }, radius = 1600 },
	bird_area = { pos = { -3000, -1600, 1000 }, radius = 500 },
	reptile_area = { pos = { -800, -2000, 1000 }, radius = 500 },

	default_camera = { -1300, -2000, 1500},
	palma_airport_pos = { -2980, -1640, 250 },

	fields = { 39580, 4828, 39579, 37457, 10251, 2552, 37459, 37458, 37456, 37460, 2414, 37455, 37461, 37462, },

	restree = {
		construction = {
			station = {
				air = {
					["airport_2nd_runway.module"] = modifier.util.availability(missionstart, nil),
				},
			},
		},
		models = {
			model = {
				vehicle = {
					train = {
						["br_e94_v2.mdl"] = 1,
						["re_44i_v2.mdl"] = 1,
						["nohab_m1_v2.mdl"] = 1,
						["db_v100_v2.mdl"] = 1,
						["obb_1042_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["donnerbuechse_v2.mdl"] = 1,
						["bc4_v2.mdl"] = 1,
						["kesselwagen_1950_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["rungenwagen_1950.mdl"] = modifier.util.cargotypes({ "LOGS", "STEEL", "PLANKS", "CONSTRUCTION_MATERIALS" }),
						["open_1975.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "STONE", "GRAIN" }),
						["hbi1_v2.mdl"] = modifier.util.cargotypes({ "LIVESTOCK", "PLASTIC", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						default = modifier.util.disable,
					},
					bus = {
						["saurer_tuescher_v2.mdl"] = 1,
						["benz_o6600_v2.mdl"] = 1,
						["man_sl_192_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					tram = {
					},
					truck = {
						["man_19_304_1970_universal_v2.mdl"] = modifier.util.cargotypes({ "FUEL", "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						["man_19_304_1970_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["man_19_304_1970_tipper_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "STONE", "GRAIN" }),
						["saurer_c_typ_universal_v2.mdl"] = modifier.util.cargotypes({ "FUEL", "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						["saurer_c_typ_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["saurer_c_typ_tipper_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "STONE", "GRAIN" }),
						["saurer_c_typ_stake_v2.mdl"] = modifier.util.cargotypes({ "LOGS", "STEEL", "PLANKS", "CONSTRUCTION_MATERIALS" }),
						default = modifier.util.disable,
					},
					plane = {
						["douglas_dc4_v2.mdl"] = 1,
						--bristol freighter!
						["super_connie_v2.mdl"] = 1,
						["super_connie_cargo_v2.mdl"] = modifier.util.cargotypes({ "FUEL", "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						["douglas_c49_skytrain_v2.mdl"] = modifier.util.cargotypes({ "FUEL", "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						default = modifier.util.disable,
					},
					ship = {
						["votrans_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["viola_v3.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["votrans_universal_v2.mdl"] = modifier.util.cargotypes({ "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						["gms_axalp_v2.mdl"] = modifier.util.cargotypes({ "LOGS", "LIVESTOCK", "COAL", "IRON_ORE", "STONE", "GRAIN", "STEEL", "PLANKS", "PLASTIC", "CONSTRUCTION_MATERIALS", "MACHINES", "TOOLS", "FOOD", "GOODS", "ALCOHOL" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},

}

t.beach = { pos = {
	0.5 * (t.inca_beach1[1] + t.inca_beach2[1]),
	0.5 * (t.inca_beach1[2] + t.inca_beach2[2])
} }
t.finca_party_alocohol = t.finca_party_alcohol --typo in po files in some languages

setmetatable(t, require "mission.params_mt")

return t
