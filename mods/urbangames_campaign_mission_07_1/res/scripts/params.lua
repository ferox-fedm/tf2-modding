local modifier = require "mission.modifier"

local missionstart = 1904
local missionend = 1914

local t = {
	missionstart = missionstart,
	missionend = missionend,

	paris = 26657,
	lemans = 27115,
	reims = 17457,
	calais = 5705,
	dover = 21264,
	london = 22854,

	airfield_paris = 8511,
	airfield_lemans = 8462,
	airfield_reims = 7679,
	airfield_calais = 11881,
	airfield_dover = 21245,
	airfield_london = 21775,

	machines_factory = 21226,
	sawmill = 21229,
	champagne_factory = 5228,
	fuel_factory = 11575,
	steel_mill = 25413,

	workshop_player = 12388,
	workshop_paris = 13542,
	workshop_lemans = 13508,
	workshop_reichelt = 17652,

	tribune_lemans = 13582,
	tribune_reims = 13645,
	tribune_calais = 13735,

	latham_plane = 17038,
	airfield_latham = 15676,

	machines_1a = 15,
	planks_2a = 20,
	parts_2b = 30, -- unused?
	persons_2b = 30,
	machines_3a = 30,
	parts_3b = 35, -- unused?
	fuel_3b = 35,
	fuel_4a = 35,
	champagne_4b = 30,
	planks_4b = 35,
	persons_4b = 40,
	persons_5c = 9,
	parts_5c = 40, -- unused?
	planks_m1a = 1,
	champagne_m1b = 1,
	lathamcount = 15,

	airport_landings = 2,
	flight_distance = 2000,

	parts_paris = 50,
	specialists_lemans = 50,
	people_lemans = 5,

	eiffeltower = 23552,

	restree = {
		models = {
			model = {
				characters = {
					["era_b_driver_air_indoor.mdl"] = modifier.util.availability(missionstart, missionend),
					["era_b_driver_air_outdoor.mdl"] = modifier.util.availability(missionstart, missionend),
				},
				vehicle = {
					train = {
						["br53_preus_g3_v2.mdl"] = 1,
						["br89_v2.mdl"] = 1,
						["plm_220_v2.mdl"] = 1,
						["a3_5_705_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					waggon = {
						["wagen_bayrisch_1865_v2.mdl"] = 1,
						["compartment_car_v2.mdl"] = 1,
						["goods_1850_v2.mdl"] = modifier.util.all(modifier.util.cargotypes({ "MACHINES", "CHAMPAGNE", "PLANE_PARTS", }), modifier.util.availability(nil, missionend)),
						["kesselwagen_1860.mdl"] = modifier.util.all(modifier.util.cargotypes({ "FUEL" }), modifier.util.availability(nil, missionend)),
						["rungenwagen_1850.mdl"] = modifier.util.all(modifier.util.cargotypes({ "STEEL", "PLANKS" }), modifier.util.availability(nil, missionend)),
						default = modifier.util.disable,
					},
					bus = {
						["obeissante_v2.mdl"] = 1,
						["landauer_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					tram = {
						["dampftram_v2.mdl"] = 1,
						["halle_v2.mdl"] = 1,
						["schst_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					truck = {
						["horse_cart_universal_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "PLANKS", "FUEL", "CHAMPAGNE", "MACHINES", "PLANE_PARTS" }),
						["dmg_cannstatt_v2.mdl"] = modifier.util.cargotypes({ "STEEL", "PLANKS", "FUEL", "CHAMPAGNE", "MACHINES", "PLANE_PARTS" }),
						default = modifier.util.disable,
					},
					plane = {
						["bleriot_xi.mdl"] = modifier.util.availability(missionstart, missionend),
						default = modifier.util.disable,
					},
					ship = {
						["rigi.mdl"] = modifier.util.disable,
						["frontenac_v2.mdl"] = modifier.util.disable,
						["klondike_v2.mdl"] = modifier.util.cargotypes({ "CHAMPAGNE", "PLANE_PARTS" }),
						["wilhelm_v2.mdl"] = modifier.util.cargotypes({ "CHAMPAGNE", "PLANE_PARTS" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
