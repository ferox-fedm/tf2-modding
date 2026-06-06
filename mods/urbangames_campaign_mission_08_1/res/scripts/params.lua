local modifier = require "mission.modifier"

local missionstart = 1920
local missionend = 1930

local t = {
	missionstart = missionstart,
	missionend = missionend,

	tramailine = 11967,

	oilwell = 22875,
	cmplant = 9602,
	quarry = 9263,
	asphaltplant = 9116,
	oilrefinery = 1529,
	fuelfactory = 23101,
	farm1 = 9271,
	farm2 = 19531,
	foodprocessing = 1826,

	constructionsite1 = 9469,
	constructionsite2 = 9480,

	gasstation1 = 22929, --minneapolis
	gasstation2 = 22868, --st. paul
	gasstation3 = 15716, --st. cloud
	gasstation4 = 21284, --eau claire
	gasstation5 = 11356, --la crosse
	gasstation6 = 18956, --rochester

	minneapolis = 23079,
	stpaul      = 18934,
	stcloud     = 11484,
	eauclaire   = 11375,
	lacrosse    = 12180,
	rochester   = 17887,

	trainingcenter = 13234,

	tramstop1 = 16437,
	tramstop2 = 17165,
	tramstop3 = 17224,
	tramstop4 = 16790,
	tramstop5 = 23596,
	tramstop6 = 11807,

	tram1 = 17486,
	tram2 = 17496,
	tram3 = 17497,
	tram4 = 17498,

	persons_1a = 10,
	conmat_3a = 11,
	asphalt_3a = 12,
	trees_m4 = 600,
	grain_m3a = 300,
	distinct_colors = 5,

	initialbuscount = 3,
	initialtruckcount = 3,
	trainingarea = { pos = { -281, 1035 }, radius = 350 },
	trainingarea_zone = {
		{ 25, 1100 },
		{ -535, 1255 },
		{ -605, 1015 },
		{ -95, 850 },
	},

	goal_licence = 3,
	goal_passengers = 50,
	progress_licence = 2,
	goal_department = 2,
	progress_department = 1,

	goal_fuel = 100,
	progress_fuel = 250, -- unused?
	goal_constrmat = 100,
	goal_asphalt = 100,

	licensecost = {
		stcloud =    1000000,
		eauclaire =  4000000,
		lacrosse =   5000000,
		rochester =  6000000,
	},

	licenseid2name = {
		"stcloud",
		"eauclaire",
		"lacrosse",
		"rochester",
	},

	areaminneapolis = {
		{ -1900, -1300 },
		{   200, -1300 },
		{   200,  3072 },
		{ -1900,  3072 },
	},

	areastcloud = {
		{ -3072, -1300 },
		{ -1900, -1300 },
		{ -1900,  3072 },
		{ -3072,  3072 },
	},

	areaeauclaire = {
		{   200, -1300 },
		{  3072, -1300 },
		{  3072,  3072 },
		{   200,  3072 },
	},

	arealacrosse = {
		{  -400, -3072 },
		{  3072, -3072 },
		{  3072, -1300 },
		{  -400, -1300 },
	},

	arearochester = {
		{ -3072, -3072 },
		{  -400, -3072 },
		{  -400, -1300 },
		{ -3072, -1300 },
	},

	restree = {
		models = {
			model = {
				vehicle = {
					train = {
						usa = {
							["milw_ep_2_v2.mdl"] = 1,
							["heavy_mikado_v2.mdl"] = 1,
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					waggon = {
						usa = {
							["tankcar_1899.mdl"] = modifier.util.cargotypes({ "CRUDE", "OIL", "FUEL" }),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					bus = {
						usa = {
							["schneider_pb2_v2.mdl"] = modifier.util.all(
								modifier.util.availability(missionstart, nil),
								function(data) data.metadata.roadVehicle.topSpeed = 50 / 3.6 end
							),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					tram = {
						default = modifier.util.availability(1850, 1850), --don't make unavailable (i.e. 1849) because it will crash because of missing driver
					},
					plane = {
						default = modifier.util.disable,
					},
					truck = {
						usa = {
							["mack_ac_stake_v2.mdl"] = modifier.util.all(
								modifier.util.availability(missionstart, nil),
								modifier.util.cargotypes({ "ASPHALT", "CONSTRUCTION_MATERIALS", "STONE", "OIL", "FUEL", "GRAIN", "FOOD" }),
								function(data) data.metadata.roadVehicle.topSpeed = 50 / 3.6 end
							),
							default = modifier.util.disable,
						},
						default = modifier.util.disable,
					},
					ship = {
						["vandal_v2.mdl"] = modifier.util.cargotypes({ "OIL", "FUEL" }),
						default = modifier.util.disable,
					},
				},
			},
		},
	},
}

setmetatable(t, require "mission.params_mt")

return t
