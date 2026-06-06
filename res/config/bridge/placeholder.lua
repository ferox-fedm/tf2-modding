local bridgeutil = require "bridgeutil"

function data()

local dir = "bridge/"

local config = {
	pillarBase = { dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl" },
	pillarRepeat = { dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl" },
	pillarTop = { dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl" },

	railingBegin = {
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl",
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
	},
	railingRepeat = {
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl",
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
	},
	railingEnd = {
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl",
		dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", dir .. "placeholder_bridge.mdl", 
	},
	
	
}

return {
	name = _("Placeholder bridge"),

	yearFrom = -1,
	yearTo = -1,

	carriers = { "RAIL" , "ROAD"},

	speedLimit = 90.0 / 3.6,
	
	pillarLen = 3,
	
	pillarMinDist = 10000.0,
	pillarMaxDist = 10000.0,
	pillarTargetDist = 10000.0,

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
