function data()
return {
	numLanes = 1,
	streetWidth = 20.0,
	sidewalkWidth = 8.0,
	sidewalkHeight = 0,
	yearFrom = 1925,
	yearTo = 0,
	aiLock = true,
	country = true,
	speed = 35.0,
	transportModesStreet = { "SMALL_AIRCRAFT" },
	transportModesSidewalk = { },
	name = _("Airfield runway"),
	desc = _("Airfield grass runway with a speed limit of %2%."),
	materials = {
		streetPaving = {
			name = "street/airport/airport_runway_small_paving.mtl",
			size = { 16, 16}
		},		
		streetBorder = {
			name = "street/airport/airport_runway_small_border.mtl",
			size = { 32, 2.0 }		
		},			
		streetLane = {
			name = "street/airport/airport_runway_small_lane.mtl",
			size = { 32.0, 8.0 }
		},
		streetStripe = {
			
		},
		streetStripeMedian = {
			name = "",
		},
		streetTram = {
			name = "street/old_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		streetTramTrack = {
			name = "street/old_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		streetBus = {
			name = "",
		},
		crossingLane = {
			name = "street/airport/airport_runway_small_lane.mtl",
			size = { 32.0, 8.0 }
		},
		crossingBus = {
			name = "",
		},
		crossingTram = {
			name = "street/old_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		crossingTramTrack = {
			name = "street/old_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		crossingCrosswalk = {
			name = ""		
		},
		sidewalkPaving = {
			name = ""
		},
		sidewalkLane = {
			name = "",
			size = { 32.0, 8.0 }		
		},
		sidewalkBorderInner = {
			name = "street/airport/airport_runway_small_sidewalk_lane.mtl",
			size = { 32.0, 8.0 }
		},
		sidewalkBorderOuter = {
			name = "",
			size = { 32.0, 8.0 }
		},
		sidewalkCurb = {
		},
		sidewalkWall = {
		}	
	},
	cost = 42.0,
}
end
