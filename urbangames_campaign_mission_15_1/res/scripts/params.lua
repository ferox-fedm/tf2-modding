local modifier = require "mission.modifier"

local missionstart = 1980
local missionend = 1990

local t = {

	miami = 3166,
	havanna = 7853,
	nassau = 7402,
	keywest = 6715,
	westpalmbeach = 7799,
	fortmyers = 5090,

	harbor_cuba = 2050,
	harbor_miami = 7456,
	harbor_everglades = 8153,

	distillery = 7952,
	cigarfactory = 1240,
	goodsfactory = 8127,
	farm = 7930,
	foodprocessing = 1120,
	conmatplant = 8115,

	nassau_airport = 1528,
	cuba_airport = 4568,
	miami_airport = 3373,

	everglades = 1258,
	catering = 1205,

	--1:
	fruit_amount = 100,
	rum_amount = 50,
	cigars_amount = 50,
	police_boat_area = { pos = { 340, -270 }, radius = 170 },
	police_boat_seconds = 240,

	--2:
	passenger_amount_air = 50,
	rum_amount_air = 25,
	cigars_amount_air = 25,
	police_air_seconds = 240,

	--3:
	cigars_amount_myers = 25,
	conmat_amount_myers = 75,
	rum_amount_palm = 25,
	conmat_amount_palm = 75,
	police_road_area = { radius = 170 },
	police_road_seconds = 240,
	decisionlocater = { pos = { -250, 1000, 1000 } },

	--4:
	destroy_seconds = 10,
	destroy_amount = 3,
	blockade_area = { pos = { -750, 920 }, radius = 170 },
	race_area = { pos = { -500, 0}, radius = 250},
	airplane_area = { pos = { -750, -200}, radius = 170},
	food_amount = 50,
	scoutlocator =  { pos = {-600, -250, 1500 } },
	bridgelocator = { pos = { -700, -550, 1000 } },

	--5:
	people_amount_westpalmbeach = 30,
	food_amount_westpalmbeach = 50,
	people_amount_everglades = 50,
	money_amount_everglades = 100000,
	people_amount_keys = 20,
	keywest_radius = 300,

	--m1:

	--m2:
	crocodile_area = { pos = { -350, -280 }, radius = 200 },
	crocodile_boat_count = 5,

	--m3:
	block_percent = 0.4,
	block_percent_text = 40,

	missionstart = missionstart,
	missionend = missionend,

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						default = modifier.util.disable,
					},
					waggon = {
						default = modifier.util.disable,
					},
					bus = {
						usa = { 
							["gm_fishbowl_v2.mdl"] = 1,
							["chevrolet_c60_1974_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						asia = {
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					truck = {
						usa = {
							["american_truck_359_v2.mdl"] = modifier.util.cargotypes({ "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
							default = modifier.util.disable,
						},
						asia = {
							["isuzu_elf_tld20_universal_v2.mdl"] = modifier.util.cargotypes({ "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					ship = {
						["srn6_v2.mdl"] = 1,
						["graf_zeppelin_v2.mdl"] = 1,
						["votrans_universal_v2.mdl"] = modifier.util.cargotypes({ "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
						["gms_axalp_v2.mdl"] = modifier.util.cargotypes({ "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
						default = modifier.util.disable,
					},
					plane = {
						["short_330_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
						["bristol_freighter_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "RUM", "CIGARS", "FRUIT", "GOODS", "CONSTRUCTION_MATERIALS", "FOOD" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
