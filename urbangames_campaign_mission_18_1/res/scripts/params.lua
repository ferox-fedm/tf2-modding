local modifier = require "mission.modifier"

local missionstart = 2010
local missionend = 2030

local t = {

	shanghai = 4086,
	nantong = 24287,
	wuxi = 24741,
	suzhou = 5437,
	jiaxing = 12166,
	hangzhou = 3382,

	fuelrefinery = 3078,
	toolsfactory = 24814,
	conmatplant = 20960,
	machinesfactory = 20991,
	foodfactory = 793,
	goodsfactory = 958,
	export = 899,
	pearl = 24500,

	default = { pos = { 0, 0, 2500 } },

	--1:
	choice1_1 = {
		numairports = 4,
		numplanes = 12,
		numpassengersair = 200,
	},

	choice1_2 = {
		numtrainstations = 4,
		numtrains = 12,
		numpassengersrail = 200,
	},

	--2:
	choice2_1 = {
		highwaymeters = 8000,
		private = 4000,
	},

	choice2_2 = {
		public = 2000,
		persons = 200,
	},

	--3:
	choice3_1 = {
		machines = 200,
		conmat = 200,
		fuel = 200,
	},

	choice3_2 = {
		food = 200,
		tools = 200,
		goods = 200,
	},

	--4:
	choice4_1 = {
		residential = 5000,
	},

	choice4_2 = {
		commercial = 5000,
		industrial = 5000,
	},

	--5:
	earnings = 10000000,
	companyscore = 12,

	--m1:
	export_amount = 100,
	import_amount = 100,

	--m2:
	trafficrating = 0.8, -- \in [0, 1]
	transportrating = 0.8, -- \in [0, 1]
	trafficrating_formated = "80%",
	transportrating_formated = "80%",

	--m3:
	pearlworkers = 200,

	missionstart = missionstart,
	missionend = missionend,

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						asia = {
							["china_df5_v2.mdl"] = 1,
							["china_df4b_v2.mdl"] = 1,
							["china_ss9g_v2.mdl"] = 1,
							["china_hxd3b_v2.mdl"] = 1,
							["china_df5_v2.mdl"] = 1,
							["fuxing_hao_front_v2.mdl"] = 1,
							["fuxing_hao_middle1_v2.mdl"] = 1,
							["fuxing_hao_middle2_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					waggon = {
						asia = {
							["china_type_25_v2.mdl"] = 1,
							["china_type_25c_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						["boxcar_2000.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES" }),
						["stake_car_2000.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }),
						["tankcar_2000.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						default = modifier.util.disable,
					},
					bus = {
						asia = {
							["maz_103_v2.mdl"] = 1,
							["zuhai_gtq_6186bevbt3_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						["ecitaro_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					truck = {
						asia = {
							["faw_jiefang_j6p_universal_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
							["faw_jiefang_j6p_stake_v2.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }),
							["faw_jiefang_j6p_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
							default = modifier.util.disable,
							["gaz_3307_universal_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
							["gaz_3307_tanker_v2.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						},
						default = modifier.util.disable,
					},
					ship = {
						["herkules_xi_v3.mdl"]  = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["herkules_xi_tanker_v3.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["virgo_universal_v3.mdl"]  = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["virgo_tanker_v3.mdl"] = modifier.util.cargotypes({ "FUEL" }),
						["srn6_v2.mdl"] = 1,
						["graf_zeppelin_v2.mdl"] = 1,
						["damen_ferry_v2.mdl"] = 1,
						--default = modifier.util.disable,
					},
					plane = {
						["bombardier_dhc_8_402pf_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["boeing_737_700_c_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["tupolev_tu_204_cargo_v2.mdl"] = modifier.util.cargotypes({ "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						["bombardier_cs300_v2.mdl"] = 1,
						["boeing_737_700_v2.mdl"] = 1,
						["tupolev_tu_204_v2.mdl"] = 1,
						["short_330_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "FOOD", "GOODS", "TOOLS", "MACHINES", "CONSTRUCTION_MATERIALS", "FUEL" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

t.cities = {
	t.shanghai,
	t.nantong,
	t.wuxi,
	t.suzhou,
	t.jiaxing,
	t.hangzhou,
}

setmetatable(t, require "mission.params_mt")

return t
