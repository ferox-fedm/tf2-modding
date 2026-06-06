local modifier = require "mission.modifier"

local t = {
	missionstart = 1880,
	missionend = 1895,

	steel_task_ships_deliver = 10,
	steelpership = 50,
	lineusage_3c = 0.3,
	whiskey_glasgow = 25,
	fish_glasgow = 25,
	amount_m1b = 10,
	passengers_m3b = 15,
	fish_m5a = 0.3,
	glasgow_passengers = 20,

	glasgow = 1948,
	glasgow_steelmill = 5129,
	glasgow_pub = 4901,
	glasgow_coal = 4675,
	glasgow_iron = 4657,

	fortwilliam = 4138,

	mallaig_fishery = 5300,

	portellen_harbor = 1661,
	portellen_distillery = 4945,

	stone1 = 7244,
	stone2 = 7246,
	stone3 = 7248,
	stone4 = 7231,
	stone5 = 7242,
	horse = 7208,
	horse_line = 7225,

	glasgow_harbor_zone = { pos = { 1270, -900 }, radius = 250 },
	open_sea_zone = { pos = { -300, -1600, 700 } },

	firth_cam = { pos = { 1300, -900, 700 } },

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						["d1_3_v2.mdl"] = 1,
						["borsig_1860_v2.mdl"] = 1,
						["br53_preus_g3_v2.mdl"] = 1,
						["br89_v2.mdl"] = 1,
						["plm_220_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["d1_spanischb_v2.mdl"] = 1,
						["wagen_bayrisch_1865_v2.mdl"] = 1,
						["compartment_car_v2.mdl"] = 1,
						["rungenwagen_1850.mdl"] = modifier.util.cargotypes({ "STEEL" }),
						["rungenwagen_1890.mdl"] = modifier.util.cargotypes({ "STEEL" }),
						["open_1850.mdl"] = modifier.util.cargotypes({ "GRAIN", "COAL", "IRON_ORE" }),
						["goods_1850_v2.mdl"] = modifier.util.cargotypes({ "WHISKEY", "FISH" }),
						default = modifier.util.disable,
					},
					ship = {
						["wilhelm_v2.mdl"] = function(data)
							modifier.util.cargotypes({ "STEEL", "GRAIN", "COAL", "IRON_ORE", "WHISKEY", "FISH" })(data)
							data.metadata.waterVehicle.topSpeed = 9
							data.metadata.waterVehicle.availPower = 500000
						end,
						["dunara_castle.mdl"] = function(data)
							modifier.util.cargotypes({ "STEEL", "GRAIN", "COAL", "IRON_ORE", "WHISKEY", "FISH" })(data)
							data.metadata.waterVehicle.topSpeed = 11
							data.metadata.waterVehicle.availPower = 800000
						end,
						default = modifier.util.disable,
					},
					truck = {
						["horse_cart_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "GRAIN", "COAL", "IRON_ORE", "WHISKEY", "FISH" }),
						["dmg_cannstatt_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "GRAIN", "COAL", "IRON_ORE", "WHISKEY", "FISH" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},

}

setmetatable(t, require "mission.params_mt")

return t
