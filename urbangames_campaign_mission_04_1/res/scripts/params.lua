local modifier = require "mission.modifier"

local missionstart = 1885
local missionend = 1895

local t = {
	missionstart = missionstart,
	missionend = missionend,

	city_material_logs = 30,
	alcohol_2 = 20,
	spoon_2 = 40,
	paper_2 = 50,
	export_spoon = 60,
	export_alcohol = 30,
	export_amount = 45,
	marriage_transport_people = 10,
	happiness_mine_logs = 20,
	happiness_farm_guano = 10,
	happiness_trees = 100,
	duration_4e = 6,
	retreat_sell_material = 90,
	tram_smell_people = 10,
	tram_technology_people = 10,

	--shipline = 347,

	topolobampo = 5807,
	elfuerte = 7353,
	export = 7599,
	platform = 5196,
	cactus_farm = 7566,

	hospital = 5554,
	--library = 11201,
	hotel = 6509,
	guano_farm = 3608,
	guano_deposit = 7362,
	log_deposit = 6539,
	spoon_factory = 1070,
	distillery = 4039,
	forest = 7100,
	silverore_mine = 7438,
	sale = 7400,

	harbor_export = 5417,

	northern_bays = { pos = {-1030, 750} },

	worm1 = { pos = { 602, -1255 } },
	worm2 = { pos = { -1083, -515 } },
	worm3 = { pos = { -862, 1274 } },

	zone_4ca = { pos = { 1787, -3443 }, radius = 200 },

	restree = {
		models = {
			model = {
				vehicle = {
					waggon = {
						usa = {
							["boxcar_1850.mdl"] = modifier.util.cargotypes({ "ALCOHOL", "SPOON", "CACTUS" }),
							["gondola_1850.mdl"] = modifier.util.cargotypes({ "STONE", "SILVER_ORE", "GUANO" }),
							["stake_car_1850.mdl"] = modifier.util.cargotypes({ "LOGS" }),
							["pullman_1850_v2.mdl"] = 1,
							["pullman_1876_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
					},
					ship = {
						["wilhelm_v2.mdl"] = modifier.util.cargotypes({ "LOGS", "ALCOHOL", "GUANO", "SPOON", "STONE", "CACTUS", "SILVER_ORE" }),
						["dunara_castle.mdl"] = modifier.util.cargotypes({ "PASSENGERS", "LOGS", "ALCOHOL", "GUANO", "SPOON", "STONE", "CACTUS", "SILVER_ORE" }),
						["frontenac_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					bus = {
						default = modifier.util.disable,
					},
					truck = {
						usa = {
							["american_horse_cart_universal_v2.mdl"] = modifier.util.cargotypes({ "LOGS", "ALCOHOL", "GUANO", "SPOON", "STONE", "CACTUS", "SILVER_ORE" }),
							default = modifier.util.disable,
						}
					},
					tram = {
						usa = {
							["san_diego_v2.mdl"] = modifier.util.availability(missionstart, missionend),
						},
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
