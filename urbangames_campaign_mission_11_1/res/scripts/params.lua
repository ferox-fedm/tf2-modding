local modifier = require "mission.modifier"

local missionstart = 1949
local missionend = 1959

local t = {
	missionstart = missionstart,
	missionend = missionend,
	millisperday = 8000,

	chengdu = 18029,
	leshan = 19889,
	zigong = 18696,
	ziyang = 19908,
	neijiang = 21789,
	suining = 21107,
	luzhou = 15206,
	chongqing = 15112,
	nanchong = 20441,
	guangan = 18964,
	cities = { "chengdu", "leshan", "zigong", "ziyang", "neijiang", "suining", "luzhou", "chongqing", "nanchong", "guangan" },

	constructionsite1 = 4509,
	constructionsite2 = 22362,
	constructionsite3 = 8644,
	constructionsite4 = 2275,
	constructionsite5 = 23014,
	constructionsite6 = 10453,
	constructionsite7 = 838,
	constructionsite8 = 3455,
	--storage1 = 6816,
	--storage2 = 5610,
	--storage3 = 3455,
	trackindustry = 4012,
	ironmine_east = 7624,
	ironmine_west = 7703,
	coalmine_east = 22371,
	coalmine_west = 11901,
	steelmill_east = 22361,
	steelmill_west = 6437,
	damsite = 25413,
	machinesimport = 9990,
	machinesimport2 = 821,
	machinesimport3 = 17451,

	trainstation_chengdu = 16808,
	trainstation_chongqing = 8824,
	trainstation_neijiang = 25223,
	trainstation_ziyang = 23505,

	trackstart = 5000,
	trackgoal = 2000,
	tracksteelgoal = 50,
	kmpermonth3 = 300,
	kmpermonth4_max = 125,

	people_total2 = 1750, -- unused?
	cargo2 = 75,
	people_total3 = 1300,
	cargo3 = 75,
	people_total4 = 2250, -- unused?
	cargo4 = 200, -- unused?
	people_total5 = 2500, -- unused?
	cargo5 = 250, -- unused?

	grain_store = 200,
	chemicalplant_amount = 2,
	steel_amount = 50,

	amount_machines_to_farm = 10,
	amount_machines_m2 = 50,
	bulldoze_count = 3,

	dam_steel = 200,
	dam_machines = 100,
	dam_grain = 300,

	pesticide_zone1 = { pos = { -1482,  -770 }, radius = 250 },
	pesticide_zone2 = { pos = {   -50,  1825 }, radius = 250 },

	default_camera = { 0, 0, 1500 },

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						asia = {
							["russian_class_s_v2.mdl"] = 1,
							["russian_class_ye_v2.mdl"] = 1,
							["china_jf1_v2.mdl"] = 1,
							["russian_class_su_v2.mdl"] = 1,
							["russian_class_fd_v2.mdl"] = 1,
							["russian_class_l_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					waggon = {
						asia = {
							["suburban_2nd_v2.mdl"] = 1,
							["egorov_20_2_v2.mdl"] = 1,
							["gondola_as_1950.mdl"] = modifier.util.all(modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN" }), modifier.util.availability(missionstart, nil)),
							["stake_car_as_1950.mdl"] = modifier.util.all(modifier.util.cargotypes({ "STEEL" }), modifier.util.availability(missionstart, nil)),
							["boxcar_as_1950.mdl"] = modifier.util.all(modifier.util.cargotypes({ "MACHINES", "FOOD", "GOODS", "PLASTIC" }), modifier.util.availability(missionstart, nil)),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					bus = {
						asia = {
							["fuso_b46_v2.mdl"] = 1,
							["zis_155_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					tram = {
						asia = {
						},
					},
					truck = {
						asia = {
							["gaz_mm_universal_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "STEEL", "MACHINES", "FOOD", "GOODS", "PLASTIC" }),
							["gaz_mm_stake_v2.mdl"] = modifier.util.cargotypes({ "STEEL" }),
							["zis_150_universal_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "STEEL", "MACHINES", "FOOD", "GOODS", "PLASTIC"}),
							["zis_150_tipper_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN" }),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					ship = {
						["ds_schaffhausen_v2.mdl"] = 1,
						["zurich_v2.mdl"] = 1,
						["klondike_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "STEEL", "MACHINES", "FOOD", "GOODS", "PLASTIC" }),
						["votrans_universal_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "STEEL", "MACHINES", "FOOD", "GOODS", "PLASTIC" }),
						default = modifier.util.disable,
					},
					plane = {
						["douglas_dc3_v2.mdl"] = 1,
						["douglas_dc4_v2.mdl"] = 1,
						["douglas_dc4_v2.mdl"] = 1,
						["douglas_c49_skytrain_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "STEEL", "MACHINES", "FOOD", "GOODS", "PLASTIC" }),
						--bristol_freighter?
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

local mt = require "mission.params_mt"
local mt2 = {
	__index = function(self, key)
		if key == "numconsites" then
			local i = 1
			while self["constructionsite" .. i] do
				i = i + 1
			end
			return i - 1
		end
		return mt.__index(self, key)
	end
}
setmetatable(t, mt2)

return t
