function data()
return {
numLanes = 1,
	streetWidth = 10.0,
	sidewalkWidth = 8.0,
	sidewalkHeight = 0.0,
	yearFrom = 1925,
	yearTo = 0,
	aiLock = true,
	country = true,
	speed = 30.0,
	transportModesStreet = { "SMALL_AIRCRAFT" },
	transportModesSidewalk = { },
	name = _("Airfield taxiway"),
	desc = _("Airfield grass taxiway with a speed limit of %2%."),
	materials = {
		streetPaving = {
			--name = "street/airport/airport_taxiway_small_paving.mtl",
			size = { 16, 16}
		},		
		streetBorder = {
			--name = "street/airport/airport_runway_small_border.mtl",
			size = { 32, 2.0 }
		},			
		streetLane = {
			--name = "street/airport/airport_runway_small_lane.mtl",
			size = { 32.0, 8.0 }
		},
		streetStripe = {
			
		},
		streetStripeMedian = {
			name = "",
		},
		streetTram = {
			name = "",
			size = { 2.0, 2.0 }
		},
		streetBus = {
			name = "",
		},
		crossingLane = {
			--name = "street/airport/airport_runway_small_lane.mtl",
			size = { 32.0, 8.0 }
		},
		crossingBus = {
			name = "",
		},
		crossingTram = {
			name = "",
			size = { 2.0, 2.0 }
		},
		crossingCrosswalk = {
			name = "",		
		},
		sidewalkPaving = {
			name = "",		
			size = {2,3.0}
		},
		sidewalkLane = {
			name = "",
			size = { 32.0, 6.0 }		
		},
		sidewalkBorderInner = {
			--name = "street/airport/airport_runway_small_sidewalk_lane.mtl",
			size = { 32.0, 8.0 }
		},
		sidewalkBorderOuter = {
			name = "",
			size = { 3.0, 0.6 }
		},
		sidewalkCurb = {
		},
		sidewalkWall = {
		}	
	},
	streetFillGroundTex = "none.lua",
	borderGroundTex = "none.lua",
	sidewalkFillGroundTex = "none.lua",
	cost = 24.0,
}
end
