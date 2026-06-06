local modifier = require "mission.modifier"
local colors = require "mission.colors"

local t = {
	missionstart = 1870,
	missionend = 1880,

	semarang = 5433,
	surabaya = 4102,

	coffee_farm = 6766,
	coffee_processing = 2330,
	sugar_farm = 2565,

	coffee_farm_station = 2438,

	temple1 = 8484,
	temple2 = 3155,
	temple3 = 3056,
	temple4 = 8493,

	feast_amount_1 = 10,
	feast_amount_2 = 10,
	feast_amount_3 = 10,

	num_wagons = 4,
	snap_node1 = 2080,
	snap_node2 = 6765,
	circle_signal_task1 = { pos = { 101, -308 } },
	circle_signal_task2 = { pos = { -33, -293 } },
	segments_3b = { 5849, 6755 },
	trains_2c = 2,
	vulcano_zone = { pos = { -451, -630, 700 }, radius = 400 },

	coffeefruit_amount = 30,

	num_vehicles_export_task = 4,

	coffee_amount_1c = 1,
	passenger_amount_4c = 25,
	meter_amount_driver = 1500,

	production_target = 75,
	shipping_target = 75,
	transported_target = 75,

	factory_target_level = 3,

	zone_plant = { pos = { 769, -68 }, radius = 40 },
	zone_town = { pos = { 620, 430 }, radius = 40 },
	digesteddriver = { pos = { -1866, -310, 600 }, radius = 350 },

	buildingarea_processing_center = {
		pos = { 500, -313 },
	},

	buildingArea1a_processing = {
		{ 816, -103 },
		{ 483, -232 },
		{ 155, -258 },
		{ 123, -294 },
		{ 121, -316 },
		{ 147, -359 },
		{ 553, -425 },
		{ 886, -275 },
	},

	surabaya_semarang_mid = {
		pos = { -454, 231, 1500 },
	},

	modelnames = {
		train1 = "vehicle/train/d1_3_v2.mdl",
		train2 = "vehicle/train/borsig_1860_v2.mdl",
		train3 = "vehicle/train/br53_preus_g3_v2.mdl",
		passengerwagon = "vehicle/waggon/d1_spanischb_v2.mdl",
		openwagon = "vehicle/waggon/open_1850.mdl",
		goodswagon = "vehicle/waggon/goods_1850_v2.mdl",
	},

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						["d1_3_v2.mdl"] = 1,
						["borsig_1860_v2.mdl"] = 1,
						["br53_preus_g3_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["open_1850.mdl"] = modifier.util.cargotypes({ "SUGAR" }),
						["goods_1850_v2.mdl"] = modifier.util.cargotypes({ "COFFEE", "COFFEEBEANS" }),
						["d1_spanischb_v2.mdl"] = 1,
						["wagen_bayrisch_1865_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					ship = modifier.util.disable,
					truck = modifier.util.cargotypes({ "SUGAR", "COFFEE", "COFFEEBEANS" }),
					tram = modifier.util.disable,
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
