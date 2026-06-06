local modifier = require "mission.modifier"

local missionstart = 1934
local missionend = 1954

local t = {
	missionstart = missionstart,
	missionend = missionend,

	losangeles = 2329,
	santabarbara = 25631,
	bakersfield = 26781,
	--sanjose = 26688,
	sanfrancisco = 24982,

	hugesfactory = 30408,
	villa = 10486,
	filmset1 = 29507,
	filmset2 = 29521,
	filmset3 = 29525,
	filmset4 = 29773,

	setsteel = 10,
	setplanks = 10,
	setsand = 10,

	golfcourse = 28657,
	party = 28294,
	hospital = 15276,
	premiere = 28486,
	sawmill = 29155,
	sandpit = 27533,
	foodprocessing = 14524,
	steelmill = 2173,
	distillery = 30431,
	toolsfactory = 29007,

	decoration_filmset = 10,

	num_planes_flying = 2,
	takeoffs_hellpilot = 5,
	noise_hellpilot = 64,
	passengers_tycoon = 10,
	passengers_planes = 10,
	line_minutes = 5,
	num_trees_at_golfcourse = 100,
	airfield_distance_to_golfcourse = 500,
	num_landings_at_golfcourse = 3,

	planes_1 = 3,
	planes_2 = 6,
	planes_3 = 1,

	tycoon_minutes = 3,

	airfield_bakersfield = 2013,
	airfield_santabarbara = 25876,
	--airfield_sanjose = 5305,
	airport_la = 28052,
	airport_sanfrancisco = 8456,

	trainstation_la = 28967,
	trainstation_sanfrancisco = 29141,

	golfcourse_locator = { pos = { 330, -3500}, radius = 450 },

	zone_4a4 = { pos = { -400, -4170 }, radius = 50 },
	zone_plane = { pos = { -606, -3700 }, radius = 400 },

	targetbalance = 10000000,

	aircraft = {"vehicle/plane/junkers_ju_52_v2.mdl", "vehicle/plane/dornier_b_merkur_v2.mdl", "vehicle/plane/douglas_dc3_v2.mdl", "vehicle/plane/douglas_dc4_v2.mdl", "vehicle/plane/douglas_c49_skytrain_v2.mdl" },

	default_camera = { -150, -2700, 1500},

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						usa = {
							["alco_pa_front_v2.mdl"] = modifier.util.availability(missionstart, nil),
							["alco_pb_back_v2.mdl"] = modifier.util.availability(missionstart, nil),
							["heavy_mikado_v2.mdl"] = 1,
							["milw_ep_2_v2.mdl"] = 1,
							["milw_ep_2_v2.mdl"] = 1,
							["class_9000_v2.mdl"] = 1,
							["alco_hh600_v2.mdl"] = 1,
							["hiawatha_v2.mdl"] = modifier.util.availability(missionstart, nil),
							["class_prr_gg1_v2.mdl"] = modifier.util.availability(missionstart, nil),
							["bigboy.mdl_v2"] = 1,
							default = modifier.util.disable,
						}
					},
					waggon = {
						usa = {
							["parlor_v2.mdl"] = 1,
							["pullman_1900_v2.mdl"] = 1,
							["streamlined_santa_fe_v2.mdl"] = modifier.util.availability(missionstart, nil),
							["gondola_1907.mdl"] =  modifier.util.cargotypes({ "SAND" }),
							["stake_car_1895.mdl"] =  modifier.util.cargotypes({ "STEEL", "PLANKS" }),
							["boxcar_1902.mdl"] =  modifier.util.cargotypes({ "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
							default = modifier.util.disable,
						}
					},
					bus = {
						usa = {
							["schneider_pb2_v2.mdl"] = 1,
							["twin_coach_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					tram = {
						usa = {
							["peter_witt_streetcar_v2.mdl"] = 1,
							["pcc_1643_pittsburgh_v2.mdl"] = modifier.util.availability(missionstart, nil),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					truck = {
						usa = {
							["ford_m77_universal_v2.mdl"] = modifier.util.cargotypes({ "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
							["ford_m77_stake_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "PLANKS" }),
							["mack_ac_universal_v2.mdl"] = modifier.util.cargotypes({ "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
							["mack_ac_stake_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "PLANKS" }),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					ship = {
						["ds_schaffhausen_v2.mdl"] = 1,
						["zurich_v2.mdl"] = 1,
						["klondike_v2.mdl"] = modifier.util.cargotypes({ "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
						["votrans_universal_v2.mdl"] = modifier.util.cargotypes({ "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
						default = modifier.util.disable,
					},
					plane = {
						["dornier_b_merkur_v2.mdl"] = 1,
						["junkers_f_13_v2.mdl"] = 1,
						["junkers_ju_52_v2.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
						["douglas_dc3_v2.mdl"] = 1,
						["douglas_dc4_v2.mdl"] = 1,
						["douglas_c49_skytrain_v2.mdl"] = modifier.util.cargotypes({ "SAND", "STEEL", "PLANKS", "PLASTIK", "FOOD", "ALCOHOL", "TOOLS" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
