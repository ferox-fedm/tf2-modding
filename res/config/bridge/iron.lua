local bridgeutil = require "bridgeutil"

function data()

local dir = "bridge/iron/"

local config = {
	pillarBase = { dir .. "pillar_btm_side.mdl", dir .. "pillar_btm_rep.mdl", dir .. "pillar_btm_side2.mdl" },
	pillarRepeat = { dir .. "pillar_rep_side.mdl", dir .. "pillar_rep_rep.mdl", dir .. "pillar_rep_side2.mdl" },
	pillarTop = { dir .. "pillar_top_side.mdl", dir .. "pillar_top_rep.mdl", dir .. "pillar_top_side2.mdl" },
	
	railingBegin = { 
		dir .. "railing_start_side.mdl", dir .. "railing_start_side.mdl", dir .. "railing_start_side_no_side.mdl", 
		dir .. "railing_rep_rep.mdl", dir .. "railing_rep_rep.mdl",
		dir .. "railing_end_side2.mdl", dir .. "railing_end_side2.mdl", dir .. "railing_end_side2_no_side.mdl", 
	},
	railingRepeat = { 
		dir .. "railing_rep_side.mdl", dir .. "railing_rep_side.mdl", dir .. "railing_rep_side_no_side.mdl", 
		dir .. "railing_rep_rep.mdl" , dir .. "railing_rep_rep.mdl",
		dir .. "railing_rep_side2.mdl", dir .. "railing_rep_side2.mdl", dir .. "railing_rep_side2_no_side.mdl", 
	},
	railingEnd = { 
		dir .. "railing_end_side.mdl", dir .. "railing_end_side.mdl", dir .. "railing_end_side_no_side.mdl", 
		dir .. "railing_rep_rep.mdl" , dir .. "railing_rep_rep.mdl",
		dir .. "railing_start_side2.mdl", dir .. "railing_start_side2.mdl", dir .. "railing_start_side2_no_side.mdl", 
	},
}

config.configureRailing = function(modelData, params, interval, i, length, width)
	local railingModels = { config.railingBegin, config.railingRepeat, config.railingEnd }
	
	return bridgeutil.configureRailing(modelData, interval, railingModels, length, width)
end

return {

	name = _("Iron bridge"),

	yearFrom = 1910,
	yearTo = 0,

	carriers = { "RAIL" , "ROAD"},

	speedLimit = 180.0 / 3.6,
	
	pillarLen = 3,
	
	pillarMinDist = 18.0,
	pillarMaxDist = 66.0,
	pillarTargetDist = 36.0,

	cost = 400.0,
	costFactors = { 10.0, 2.0, 1.0 },
	
	materialsToReplace = {	
		streetPaving = {
			name = "street/country_new_medium_paving.mtl",
		},
		streetLane = {
			name = "street/new_medium_lane.mtl",
		},
		crossingLane = {
			name = "street/new_medium_lane.mtl",
		},
		sidewalkPaving = {
			name = "street/new_medium_sidewalk.mtl",
		},
		sidewalkBorderInner = {
			name = "street/new_medium_sidewalk_border_inner.mtl",		
			size = { 3, 0.6 }
		},
	},
	
	updateFn = bridgeutil.makeDefaultUpdateFn(config),
}
end
