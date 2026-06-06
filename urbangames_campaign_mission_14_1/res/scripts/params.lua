local modifier = require "mission.modifier"

local missionstart = 1974
local missionend = 1984

local t = {

	bukarest = 11898,
	district1 = 15978,
	district2 = 16877,
	district3 = 17574,
	konstanza = 23236,
	alexandria = 1341,
	galati = 21291,

	oil1 = 24380,
	oil2 = 2337,
	oilrefinery = 8977,
	marble = 8763,
	steelmill = 1451,
	chemicalplant = 24441,
	goodsfactory = 2865,
	canalsite = 24466,
	export = 24463,
	tribune1 = 9733,
	tribune2 = 23105,
	tribune3 = 15658,
	tribune4 = 6597,
	marbleconsumer = 1987,
	--pageantryconsumer = 20789,

	harborkonstanza = 11298,
	harbordanube = 23979,

	tribunelocator = { pos = { 640, -700, 1500 } },
	huntlocator = { pos = { -3000, 290, 1000 } },

	--1:
	crude_amount = 1,
	oil_amount = 50,
	plastic_amount = 50,

	--2:
	people_amount = 50,
	iron_amount = 50,

	--3:
	steel_amount = 100,
	stone_amount = 100,
	people_canal_amount = 70,
	canal_coord_west = { 2315, -300 },
	canal_coord_east = { 3360, -540 },

	--4:
	plastic_district_amount = 50,
	steel_district_amount = 50,
	street_district_amount = 3,
	house_district_amount = 3,
	zone_street1 = { pos = { -1636, -650 }, radius = 30 },
	zone_street2 = { pos = { -2020, -700 }, radius = 30 },
	zone_street3 = { pos = { -1824, -950 }, radius = 30 },

	--5:
	pageantry_amount = 100,
	marble_amount = 200,
	tribune_radius = 250,

	--m1:
	zone_hunt1 = { pos = { -3333,   40 }, radius = 90 },
	zone_hunt2 = { pos = { -2800,   10 }, radius = 90 },
	zone_hunt3 = { pos = { -2950,  700 }, radius = 90 },
	tree_amount = 160,

	--m2:
	ship_unload_amount = 200,

	--m3
	tree_prosperity_amount = 200,
	people_tribune_amount = 50,

	zone_hunt = { pos = { -3000, 240, 1000 } },

	missionstart = missionstart,
	missionend = missionend,

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						asia = {
							["shinkansen_0s_back_v2.mdl"] = modifier.util.disable,
							["shinkansen_0s_front_v2.mdl"] = modifier.util.disable,
							["shinkansen_0s_middle1_v2.mdl"] = modifier.util.disable,
							["shinkansen_0s_middle2_v2.mdl"] = modifier.util.disable,
						},
					},
					waggon = {
						asia = {
							["stake_car_as_1950.mdl"] = modifier.util.cargotypes({ "STEEL", "MARBLE" }),
							["gondola_as_1950.mdl"] = modifier.util.cargotypes({ "STONE", "IRON_ORE" }),
							["boxcar_as_1950.mdl"] = modifier.util.cargotypes({ "PAGEANTRY", "PLASTIC" }),
							["tankcar_as_1950.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL" }),
							["china_type_25_v2.mdl"] = 1,
							["china_type_yz_22_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
					},
					truck = {
						asia = {
							["zis_150_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "MARBLE", "STONE", "IRON_ORE", "PAGEANTRY", "PLASTIC", "CRUDE", "OIL" }),
							["zis_150_tanker_v2.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL" }),
							["zis_150_tipper_v2.mdl"] = modifier.util.cargotypes({ "STONE", "IRON_ORE", }),
							default = modifier.util.disable,
						},
						["man_19_304_1970_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "MARBLE", "STONE", "IRON_ORE", "PAGEANTRY", "PLASTIC", "CRUDE", "OIL" }),
						["man_19_304_1970_tanker_v2.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL" }),
						["man_19_304_1970_tipper_v2.mdl"] = modifier.util.cargotypes({ "STONE", "IRON_ORE", }),
						default = modifier.util.disable,
					},
					ship = {
						["votrans_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "MARBLE", "STONE", "IRON_ORE", "PAGEANTRY", "PLASTIC" }),
						["votrans_tanker_v2.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL" }),
						["gms_axalp_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "MARBLE", "STONE", "IRON_ORE", "PAGEANTRY", "PLASTIC" }),
						["viola_v3.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL" }),
					},
					plane = {
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

t.canal_mid = { pos = {
	0.5 * (t.canal_coord_west[1] + t.canal_coord_east[1]),
	0.5 * (t.canal_coord_west[2] + t.canal_coord_east[2]),
	1000,
} }

setmetatable(t, require "mission.params_mt")

return t
