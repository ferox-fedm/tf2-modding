local stringutil = require "stringutil"
local modifier = require "mission.modifier"

local missionstart = 1930
local missionend = 1950

local t = {
	missionstart = missionstart,
	missionend = missionend,

	zurich = 29102,
	schaffhausen = 12595,
	luzern = 6806,
	friedrichshafen = 640,
	romanshorn = 33382,
	stgallen = 14062,
	bregenz = 13708,
	locarno = 16135,
	bellinzona = 26514,
	como = 31319,
	cities = { "zurich", "schaffhausen", "luzern", "friedrichshafen", "romanshorn", "stgallen", "bregenz", "locarno", "bellinzona", "como" },

	zurich_station = 15359,
	schaffhausen_station = 531,
	luzern_station = 28247,
	friedrichshafen_station = 26241,
	romanshorn_station = 30452,
	stgallen_station = 28762,
	bregenz_station = 29410,
	locarno_station = 30563,
	bellinzona_station = 27330,
	como_station = 27226,

	depot_north = 32437,
	depot_south = 32444,

	farm_north_west = 27458,
	farm_north_east = 27443,
	farm_south_west = 14315,
	farm_south_east = 33323,

	farm_north_west_station = 29651,
	farm_north_east_station = 1137,
	--farm_south_west_station = locarno!,
	farm_south_east_station = 18147,

	foodprocessing_north = 32841,
	foodprocessing_south = 33225,

	foodprocessing_north_station = 11367,
	foodprocessing_south_station = 17730,

	constructionsite_tunnel_station = 23664,
	constructionsite_north_station = 24679,

	coalmine = 9136,
	storage_north = 3052,
	storage_south = 28194,
	constructionsite_north = 24788,
	constructionsite_tunnel = 23534,
	tracknorth = 32079,
	tracktunnel = 13763,
	ironoremine = 29756,
	machinefactory = 33311,

	train1 = 26162,
	train2 = 14620,
	train3 = 14759,
	train4 = 14792,

	secrethouse1 = 31182,
	secrethouse2 = 32450,
	secrethouse3 = 22387,

	people_1b = 10,
	food_1b = 30, --percentage
	cities_1b = 2,
	trucks_2a = 10,
	trucks_2a_sell = 5,
	people_2b = 10,
	grain_2b = 100,
	food_2b = 33,
	cities_2b = 3,
	coverage_2b = 25,
	coverage_towns_2b = 2,
	buses_3b = 10,
	buses_3b_sell = 5,
	food_3c = 35,
	cities_3c = 4,
	people_3c = 10,
	coverage_3b = 15,
	grain_3b = 100,
	food_4a = 15,
	cities_4a = 5,
	people_4a = 10,
	goods_5b = 1000000, --profit
	goods_5b_formated = string.makeMoneyString(1000000),
	passengers_5b = 1000000, --profit
	passengers_5b_formated = string.makeMoneyString(1000000),
	loss_1a = 20000, --loss
	loss_1a_formated = string.makeMoneyString(20000),
	passengers_1b = 100,
	public_transport_1b = 800,
	passengers_escape = 0,

	coal_4 = 50,
	iron_4 = 50,

	machines_4 = 100,
	grain_4 = 200,

	machines_north = 25,
	machines_south = 25,
	machines_tunnel = 50,

	default_camera = { -1000, -1000, 2000 },
	gotthard_camera = { -1100, -1600, 500 },
	escape_camera = { 1100, 1700, 1500 },
	churchill_camera = { -700, 1600, 1500 },

	fields = { 22593, 22592, 22590, 22589, 22596, 22807, 22586, 22588, 22581, 22580, 22576, 22577, 22575, 22574, 22567, 22563, 22572, 22568, 22562, 22571, 22570 },

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						["a3_5_705_v2.mdl"] = 1,
						["br75_4_v2.mdl"] = 1,
						["c6_8_v2.mdl"] = 1,
						["ae_4_7_v2.mdl"] = 1,
						["br_e94_v2.mdl"] = 1,
						["roterpfeil_v2.mdl"] = modifier.util.availability(missionstart, nil),
						default = modifier.util.disable,
					},
					waggon = {
						["3axes_person_v2.mdl"] = 1,
						["donnerbuechse_v2.mdl"] = 1,
						["bc4_v2.mdl"] = 1,
						["open_1910.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN" }),
						["rungenwagen_1890.mdl"] = modifier.util.cargotypes({ "STEEL" }),
						["verbandswagen_v3.mdl"] = modifier.util.cargotypes({ "MACHINES", "FOOD" }),
						default = modifier.util.disable,
					},
					bus = {
						["postkutsche_v2.mdl"] = 1,
						["aboag_v2.mdl"] = 1,
						["saurer_tuescher_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					tram = {
						["schst_v2.mdl"] = 1,
						["typ1_v2.mdl"] = 1,
						["atm_4000_v2.mdl"] = 1,
						default = modifier.util.disable,
					},
					truck = {
						["opel_blitz_1930_universal_v2.mdl"] = modifier.util.all(
						modifier.util.availability(missionstart, nil),
						modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "MACHINES", "STEEL", "FOOD" })
						),
						["opel_blitz_1930_tipper_v2.mdl"] = modifier.util.all(
						modifier.util.availability(missionstart, nil),
						modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN" })
						),
						["saurer_c_typ_universal_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN", "MACHINES", "STEEL", "FOOD" }),
						["saurer_c_typ_stake_v2.mdl"] = modifier.util.cargotypes({ "STEEL" }),
						["saurer_c_typ_tipper_v2.mdl"] = modifier.util.cargotypes({ "COAL", "IRON_ORE", "GRAIN" }),
						default = modifier.util.disable,
					},
					plane = {
						default = modifier.util.disable,
					},
					ship = {
						default = modifier.util.disable,
					},
				},
			},
		},
	},

	tracklist_north = {
		{
			node0pos = { -1085.7391357422, 3165.0595703125, 41.395484924316, },
			node0tangent = { -7.5077409744263, 37.305065155029, -1.0240259170532, },
			node1pos = { -1094.3768310547, 3202.158203125, 40.271938323975, },
			node1tangent = { -9.7663249969482, 36.87451171875, -1.2052356004715, },
		},
		{
			node0pos = { -1094.3768310547, 3202.158203125, 40.271938323975, },
			node0tangent = { -11.781262397766, 44.482273101807, -1.453893661499, },
			node1pos = { -1107.796875, 3246.2590332031, 38.756423950195, },
			node1tangent = { -15.057035446167, 43.689548492432, -1.5458314418793, },
		},
		{
			node0pos = { -1090.6408691406, 3164.0729980469, 41.395484924316, },
			node0tangent = { -7.4468264579773, 37.002388000488, -1.0157173871994, },
			node1pos = { -1099.2081298828, 3200.8703613281, 40.272090911865, },
			node1tangent = { -9.6866273880005, 36.575412750244, -1.2095022201538, },
		},
		{
			node0pos = { -1099.2081298828, 3200.8703613281, 40.272090911865, },
			node0tangent = { -11.689433097839, 44.13773727417, -1.4595787525177, },
			node1pos = { -1112.5240478516, 3244.6298828125, 38.756423950195, },
			node1tangent = { -14.940377235413, 43.351051330566, -1.533854842186, },
		},
	},

	tracklist_mid = {
		{
			node0pos = { -1455.0275878906, -224.19033813477, 29.811235427856 },
			node0tangent = { -11.499300956726, 40.356052398682, -1.251470208168 },
			node1pos = { -1466.6215820312, -183.86152648926, 28.49094581604 },
			node1tangent = { -11.689774513245, 40.301136016846, -1.3901072740555},
		},
		{
			node0pos = { -1466.6215820312, -183.86152648926, 28.49094581604 },
			node0tangent = { -14.749549865723, 50.849872589111, -1.7539650201797 },
			node1pos = { -1481.5278320312, -133.05740356445, 26.622230529785 },
			node1tangent = { -15.065361022949, 50.757392883301, -1.9854748249054 },
		},
		{
			node0pos = { -1459.8361816406, -225.56053161621, 29.811235427856 },
			node0tangent = { -11.492832183838, 40.333351135254, -1.2507661581039 },
			node1pos = { -1471.4237060547, -185.25442504883, 28.49094581604 },
			node1tangent = { -11.683197975159, 40.278465270996, -1.389325261116 },
		},
		{
			node0pos = { -1471.4237060547, -185.25442504883, 28.49094581604 },
			node0tangent = { -14.740892410278, 50.820026397705, -1.7529355287552 },
			node1pos = { -1486.3211669922, -134.48011779785, 26.622230529785 },
			node1tangent = { -15.056517601013, 50.727600097656, -1.9843094348907 },
		},
	},

	tracklist_south = {
		{
			node0pos = { -113.82836151123, -3692.1892089844, 11.013412475586, },
			node0tangent = { -31.28953742981, 21.816898345947, 0.67713385820389, },
			node1pos = { -143.61106872559, -3668.3056640625, 12.376773834229, },
			node1tangent = { -28.341609954834, 25.838855743408, 1.9683420658112, },
		},
		{
			node0pos = { -143.61106872559, -3668.3056640625, 12.376773834229, },
			node0tangent = { -28.173748016357, 25.685817718506, 1.9566838741302, },
			node1pos = { -170.49024963379, -3640.9069824219, 14.771196365356, },
			node1tangent = { -25.649160385132, 29.002223968506, 2.7523522377014, },
		},
		{
			node0pos = { -116.68812561035, -3696.2905273438, 11.013412475586, },
			node0tangent = { -31.881479263306, 22.229633331299, 0.68994396924973, },
			node1pos = { -147.03254699707, -3671.9519042969, 12.313333511353, },
			node1tangent = { -28.873193740845, 26.334980010986, 1.9651390314102, },
		},
		{
			node0pos = { -147.03254699707, -3671.9519042969, 12.313333511353, },
			node0tangent = { -28.51007270813, 26.00378036499, 1.9404245615005, },
			node1pos = { -174.23565673828, -3644.2194824219, 14.771196365356, },
			node1tangent = { -25.95947265625, 29.353099822998, 2.7856512069702, },
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
