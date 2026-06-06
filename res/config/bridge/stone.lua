local bridgeutil = require "bridgeutil"

function data()

local dir = "bridge/stone/"

local config = {
	pillarBase = { dir .. "pillar_btm_side.mdl", dir .. "pillar_btm_rep.mdl", dir .. "pillar_btm_side2.mdl" },
	pillarRepeat = { dir .. "pillar_rep_side.mdl", dir .. "pillar_rep_rep.mdl", dir .. "pillar_rep_side2.mdl" },
	pillarTop = { dir .. "pillar_top_side.mdl", dir .. "pillar_top_rep.mdl", dir .. "pillar_top_side2.mdl" },

	railingBegin = {
		dir .. "railing_start_side.mdl", dir .. "railing_start_side.mdl", dir .. "railing_start_side_no_side.mdl", 
		dir .. "railing_start_rep.mdl", dir .. "railing_start_rep.mdl",
		dir .. "railing_end_side2.mdl", dir .. "railing_end_side2.mdl", dir .. "railing_end_side2_no_side.mdl"
	},
	railingRepeat = {
		dir .. "railing_rep_side.mdl",  dir .. "railing_rep_side.mdl",  dir .. "railing_rep_side_no_side.mdl",
		dir .. "railing_rep_rep.mdl", dir .. "railing_rep_rep.mdl",
		dir .. "railing_rep_side2.mdl",  dir .. "railing_rep_side2.mdl",  dir .. "railing_rep_side2_no_side.mdl",
	},
	railingEnd = {
		dir .. "railing_end_side.mdl",  dir .. "railing_end_side.mdl",  dir .. "railing_end_side_no_side.mdl",
		dir .. "railing_end_rep.mdl", dir .. "railing_end_rep.mdl",
		dir .. "railing_start_side2.mdl",  dir .. "railing_start_side2.mdl",  dir .. "railing_start_side2_no_side.mdl",
	},
	
	
}

return {
	name = _("Stone bridge"),

	yearFrom = 0,
	yearTo = 0,

	carriers = { "RAIL" , "ROAD"},

	speedLimit = 90.0 / 3.6,
	
	pillarLen = 3,
	
	pillarMinDist = 12.0,
	pillarMaxDist = 48.0,
	pillarTargetDist = 12.0,

	cost = 200.0,
	costFactors = { 10.0, 2.5, 1.0 },
	
	pillarGroundTexture = "shared/dirt.gtex.lua",
	pillarGroundTextureOffset = 2.0,
	
	materialsToReplace = {
		streetPaving = {
			name = "street/old_medium_paving.mtl",
			size = { 12.0, 12.0 }
		},
		streetBorder = {
			name = "street/old_medium_border.mtl",			
			size = {8,0.4}
		},				
		sidewalkPaving = {
			name = "street/old_medium_sidewalk.mtl",
			size = {5.0,5.0}
		},
		streetLane = {			
			name = "street/old_medium_lane.mtl",
			size = { 12.0, 3.0 }
		},		
		crossingLane = {
			name = "street/old_medium_lane.mtl",
			size = { 12.0, 3.0 }
		},
		sidewalkLane = {	
		
		},
		sidewalkBorderInner = {
			name = "street/old_medium_sidewalk_border_inner.mtl",
			size = { 8.0, 1.2 }
		},
		sidewalkBorderOuter = {
			name = "street/old_medium_sidewalk_border_outer.mtl",
			size = { 3.0, 0.6 }		
		},
		streetBorderOuter = {
			name = "street/old_medium_sidewalk_border_outer.mtl",
			size = { 3.0, 0.6 }
		},
	},
	
	updateFn = bridgeutil.makeDefaultUpdateFn(config),
}
end
