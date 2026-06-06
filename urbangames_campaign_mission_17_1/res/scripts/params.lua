local modifier = require "mission.modifier"

local missionstart = 1998
local missionend = 2018

local t = {

	fortmcmurray = 24235,
	athabasca = 12543,
	edmonton = 16396,

	refinery = 1060,
	oilsand1 = 1091,
	oilsand2 = 11723,
	oilsand3 = 11700,
	sedimentationtank3 = 1152,
	chemicalplant = 24140,
	conmatplant = 12511,
	goodsfactory = 8985,
	foodfactory = 8670,
	machinesfactory = 33198,
	sewage = 12495,
	--sewage2 = 12495,
	--sewage3 = 12495,
	--sewage4 = 12495,
	--sewage5 = 12495,
	--sewage6 = 12495,
	machinesdump = 30383,
	excavation = 8990,
	depot = 3073,

	default = { pos = { 0, 0, 2000, } },

	prohibitarea = {
		{ 1130, 1815 },
		{ 1024, 2260 },
		{  595, 2565 },
		{  160, 2640 },
		{  -75, 2455 },
		{   70, 2160 },
		{  224, 2140 },
		{  315, 2010 },
		{  402, 1943 },
		{  835, 1495 },
		{ 1010, 1510 },
	},

	catline1 = 940,
	catline2 = 24147,
	catline3 = 24444,

	--1:
	oilsand1output = 400,
	oilsand2output = 200,
	oilsand3output = 200,
	machines_amount = 30,
	oilsand_amount = 10,
	oil_amount = 1,
	oilsands = { pos = { 420, 2300, 1500} },

	--2:
	people_to_refinery = 30,
	public_transport = 100,
	goods_to_fort = 1,
	food_to_fort = 1,

	--3:
	fishpos1 = { 1460, 3280 },
	fishpos1marker = { pos = { 1460, 3280, 150 } },
	fishpos2 = { 1400, 1540 },
	fishpos2marker = { pos = { 1400, 1540, 150 } },
	fishpos3 = { -810,  850 },
	fishpos3marker = { pos = { -810, 850, 150 } },
	plastic_amount = 1,
	stoptime = 60,
	goodsmoney = 100000,
	nodelivery = 3,

	--4:
	plastic_amount_clean = 1,
	pay_science = 10000000,
	machines_amount_dirty = 1,
	pay_modern = 10000000,
	wastewater_amount = 60,

	--5:
	conmat_amount_catastrophe = 60,
	conmat_amount_catastrophe_max = 240,

	--m1:
	digzone = { pos = { 853, 2617 }, radius = 10 },

	--m2:

	--m3:

	missionstart = missionstart,
	missionend = missionend,

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
					},
					waggon = {
						usa = {
							["emd_sd40_v2.mdl"] = 1,
							["emd_aem_7_v2.mdl"] = 1,
							["ge_c40_8w_v2.mdl"] = 1,
							["ge_e60c_2_v2.mdl"] = 1,
							["metroliner_middle1_v2.mdl"] = 1,
							["bilevel_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						["boxcar_2000.mdl"]  = modifier.util.all(modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "MACHINES" }), modifier.util.availability(missionstart, nil)),
						["stake_car_2000.mdl"] = modifier.util.all(modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS" }), modifier.util.availability(missionstart, nil)),
						["tankcar_2000.mdl"] = modifier.util.all(modifier.util.cargotypes({ "OIL" }), modifier.util.availability(missionstart, nil)),
						default = modifier.util.disable,
					},
					bus = {
					},
					tram = {
					},
					truck = {
						usa = {
							["cascadia_2009_universal_v2.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
							["cascadia_2009_tanker_v2.mdl"] = modifier.util.cargotypes({ "OIL", "WASTE_WATER" }),
							default = modifier.util.disable,
						},
						asia = {
							["gaz_3307_universal_v2.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
							["gaz_3307_tanker_v2.mdl"] = modifier.util.cargotypes({ "OIL", "WASTE_WATER" }),
							default = modifier.util.disable,
						},
						["caterpillar_797b.mdl"] = modifier.util.all(modifier.util.cargotypes({ "OIL_SAND" }), modifier.util.availability(0, 1850)),
						default = modifier.util.disable,
					},
					ship = {
						["herkules_xi_universal_v3.mdl"]= modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						["herkules_xi_tanker_v3.mdl"] = modifier.util.cargotypes({ "OIL" }),
						["merlin_v2.mdl"] = modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						["viola_v3.mdl"] = modifier.util.cargotypes({ "OIL" }),
						default = modifier.util.disable,
					},
					plane = {
						["boeing_737_700_c_v2.mdl"]= modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						["tupolev_tu_204_cargo_v2.mdl"]= modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						["boeing_757_cargo_v2.mdl"]= modifier.util.cargotypes({ "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						["boeing_737_700_v2.mdl"] = 1,
						["tupolev_tu_204_v2.mdl"] = 1,
						["boeing_757_v2.mdl"] = 1,
						["short_330_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "CONSTRUCTION_MATERIALS", "GOODS", "FOOD", "PLASTIC", "OIL", "MACHINES" }),
						default = modifier.util.disable,
					}
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
