local modifier = require "mission.modifier"

local missionstart = 1904
local missionend = 1914

local t = {
	missionstart = missionstart,
	missionend = missionend,

	aishipline = 13279,
	airailline = 13288,

	konya = 15122,
	ergeli = 10036,
	adana = 9838,
	aleppo = 10636,
	tribe1 = 13378,
	--tribe2 = 12649,
	--tribe3 = 12707,
	well1 = 8343,
	--well2 = 12675,
	--well3 = 12661,
	constructionsite = 12711,
	stone_m1 = 9072,
	farm1 = 8699,
	farm2 = 13481,
	food_processing = 13475,
	silver_mine = 15728,
	machine_storage_harbour = 9055,

	konya_train_station = 15707,
	adana_train_station = 8465,
	adana_train_station_harbor = 6897,
	adana_harbor = 523,
	adana_harbor_hidden = 13194,
	aleppo_train_station = 15723,
	mosque = 9913,
	train = 13285,
	ship = 13287,

	line = { pos = { 0, -500, 1000 } },
	ruines = { pos = { 2250, 1200, 1500 } },
	artifacts = { pos = { 2250, 1200, 500 } },
	bushes = { pos = { 800, 1375 } },

	overview = { pos = { 0, 0, 3000 }, },
	ergeli_adana_mid = { pos = { -210, 500, 1500 }, },

	food_1a = 80,
	hq_silver_amount = 20,
	silver_deliver_amount = 20,
	machines_deliver_amount2 = 25,
	export_4 = 200,
	machines_deliver_amount = 50,
	food_m3c = 10,
	crude_amount = 40,

	numbushes = 3,
	meter_low = 220,
	meter_high = 230,

	prohibitedzone = {
		{  -521,  2048 },
		{ -1042,   261 },
		{ -4096,   193 },
		{ -4096, -1660 },
		{   570,    32 },
		{  1824,  2048 },
	},

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						["br53_preus_g3_v2.mdl"] = 1,
						["br89_v2.mdl"] = 1,
						["plm_220_v2.mdl"] = 1,
						["a3_5_705_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["kesselwagen_1910_v2.mdl"] = modifier.util.all(modifier.util.cargotypes({ "CRUDE", }), modifier.util.availability(missionstart, nil)),
						["open_1910.mdl"] = modifier.util.all(modifier.util.cargotypes({ "GRAIN", "SILVER_ORE" }), modifier.util.availability(missionstart, nil)),
						["verbandswagen_v3.mdl"] = modifier.util.all(modifier.util.cargotypes({ "FOOD", "MACHINES" }), modifier.util.availability(missionstart, nil)),
						["wagen_bayrisch_1865_v2.mdl"] = 1,
						["compartment_car_v2.mdl"] = 1,
						["3axes_person_v2.mdl"] = 1,
						["sultan_v2.mdl"] = modifier.util.availability(missionstart, missionend),
						default = modifier.util.disable,
					},
					truck = {
						["horse_cart_stake_v2.mdl"] = modifier.util.cargotypes({ "CRUDE", "GRAIN", "SILVER_ORE", "FOOD", "MACHINES" }),
						["dmg_cannstatt_v2.mdl"] = modifier.util.cargotypes({ "CRUDE", "GRAIN", "SILVER_ORE", "FOOD", "MACHINES" }),
						default = modifier.util.disable,
					},
					bus = {
						["postkutsche_v2.mdl"] = modifier.util.availability(nil, missionend),
						["obeissante_v2.mdl"] = 1,
						default = modifier.util.disable,
					}
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
