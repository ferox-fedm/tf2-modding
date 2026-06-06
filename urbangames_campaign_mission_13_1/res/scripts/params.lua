local modifier = require "mission.modifier"

local missionstart = 1960
local missionend = 1970

local t = {
	missionstart = missionstart,
	missionend = missionend,

	osaka = 36130,
	nagoya = 26616,
	tokio = 18415,

	shiga = 37535,
	hamamatsu = 27866,
	mishima = 7915,

	stonepile = 39957,
	stonedump = 40191,
	constmatdump = 41045,
	steelmill = 40202,
	conmatplant = 26866,
	foodprocessing = 32124, --40135,
	ranch = 40334, --16134,
	hq = 37023,
	fishery = 39806,

	tmg = 2000,
	bmg = 1000,

	goalnf = 3,
	goalspeed = 180,

	deliver_stone = 80,
	deliver_constmat = 80,

	deliver_steel = 80,
	deliver_constmat = 80,

	tunnel_zone = { pos = { 3150, -750 }, radius = 200 },
	bridge_zone = { pos = { -600, -2350 }, radius = 200 },

	workers = 30,

	max_emission_shiga = 60,
	max_emission_hamamatsu = 60,
	max_emission_mishima = 60,

	passengers = 400,
	payments = 5,
	cost = 20000000,

	goalcap = 600,
	goalspeed = 90,

	underwaterpos_questionsmark = { pos = { -2600, -1280, -5 } },
	underwaterpos = { pos = { -2600, -1280, 500 } },
	m3object1id = 4799,
	m3object2id = 8341,
	m3object3id = 14731,
	zone_m5 = { pos = { 4873, 2200 }, radius = 50 },

	zone_avoid = { pos = { -2078, -700 }, radius = 100 },
	payamount = 10000000,
	transportrating = 0.8,
	transportratingmuda = 0.8,
	industryrating = 0.8,
	industryshippedrating = 0.5,
	numswitches = 10,
	goodcondition = 0.9,

	goalinvfreq = 120,
	deliver_food = 50,

	standtime = 0.45,
	standtime_formated = 45,

	default = { pos = { -745, -1860, 2000 } },

	fields = { 40245, 40244, 40357, 40246, },

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						asia = {
							["shinkansen_0s_back_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_front_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_middle1_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_middle2_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							--["shinkansen_0ls_back.mdl"] = modifier.util.availability(missionstart, missionend),
							--["shinkansen_0ls_front.mdl"] = modifier.util.availability(missionstart, missionend),
							--["shinkansen_0ls_middle1.mdl"] = modifier.util.availability(missionstart, missionend),
							--["shinkansen_0ls_middle2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_back_dryellow_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_front_dryellow_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_middle1_dryellow_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["shinkansen_0s_middle2_dryellow_v2.mdl"] = modifier.util.availability(missionstart, missionend),
							["russian_class_p36_v2.mdl"] = 1,
							["russian_class_te3_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
					},
					waggon = {
						asia = {
							["stake_car_as_1950.mdl"] = modifier.util.cargotypes({ "STEEL", "CONSTRUCTION_MATERIALS" }),
							["gondola_as_1950.mdl"] = modifier.util.cargotypes({ "STONE", "GRAIN" }),
							["boxcar_as_1950.mdl"] = modifier.util.cargotypes({ "FISH", "LIVESTOCK", "FOOD" }),
							default = modifier.util.disable,
						},
					},
					truck = {
						asia = {
							["gaz_mm_stake_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "CONSTRUCTION_MATERIALS" }),
							["gaz_mm_universal_v2.mdl"] = modifier.util.cargotypes({"STEEL", "CONSTRUCTION_MATERIALS", "FISH", "STONE", "LIVESTOCK", "GRAIN", "FOOD" }),
							["zis_150_tipper_v2.mdl"] = modifier.util.cargotypes({ "STONE", "GRAIN" }),
							["zis_150_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "CONSTRUCTION_MATERIALS", "FISH", "STONE", "LIVESTOCK", "GRAIN", "FOOD" }),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					ship = {
						default = modifier.util.disable,
					},
					plane = {
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
