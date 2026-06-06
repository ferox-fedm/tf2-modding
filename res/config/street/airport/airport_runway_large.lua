function data()
return {
	numLanes = 1,
	streetWidth = 45.0,
	sidewalkWidth = 8.0,
	sidewalkHeight = 0,
	yearFrom = 1925,
	yearTo = 0,
	aiLock = true,
	country = false,
	speed = 35.0,
	priority = 1,
	transportModesStreet = { "SMALL_AIRCRAFT", "AIRCRAFT" },
	transportModesSidewalk = { },
	name = _("Large airport runway"),
	desc = _("Large airport runway with a speed limit of %2%."),
	borderGroundTex = "shared/border.gtex.lua",
	materials = {
		streetPaving = {
			name = "street/airport/airport_runway_medium_paving.mtl",
			size = { 16.0, 16.0 }
		},		
		streetBorder = {
			name = "street/airport/airport_runway_medium_border.mtl",
			size = { 32, 7.5 }		
		},			
		streetLane = {
			name = "street/airport/airport_runway_medium_lane.mtl",
			size = { 32.0, 15.0 }
		},
		streetStripe = {
			name = "street/airport/airport_runway_medium_middle_stripe.mtl",
			size = { 50.0,  1.0 }		
		},
		streetStripeMedian = {
			name = "street/airport/airport_runway_medium_middle_stripe.mtl",
			size = { 50, 1.0 }		
		},
		streetTram = {
			name = "street/new_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		streetTramTrack = {
			name = "street/new_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		streetBus = {
			name = "street/new_medium_bus.mtl",
			size = { 12, 2.7 }
		},
		crossingLane = {
			name = "street/airport/airport_runway_medium_lane.mtl",
			size = { 32.0, 15.0 }
		},
		crossingBus = {
			name = "",
		},
		crossingTram = {
			name = "street/new_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		crossingTramTrack = {
			name = "street/new_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		crossingCrosswalk = {
			name = ""		
		},
		junctionBorder = {
			name = "street/airport/airport_taxiway_medium_border.mtl",
			size = { 32, 2.0 }		
		},	
		junctionLane = {
			name = "street/airport/airport_runway_medium_lane.mtl",
			size = { 32.0, 15.0 }
		},
		junctionEntryLane = {
			name = "street/airport/airport_taxiway_medium_lane.mtl",
			size = { 32.0, 8.0 }
		},
		junctionStripeMedian = {
			name = "street/airport/airport_runway_medium_middle_stripe.mtl",
			size = { 50, 1.0 }		
		},
		junctionLine = {
			name = "street/airport/airport_runway_medium_border.mtl",
			size = { 32, 7.5 }		
		},	
		sidewalkPaving = {
			name = "street/airport/airport_runway_medium_paving.mtl",
			size = { 16.0, 16.0 }
					
		},
		sidewalkLane = {
			name = "street/airport/airport_runway_medium_sidewalk_lane.mtl",
			size = { 32.0, 4.0 }
			
		},
		sidewalkBorderInner = {
			name = "street/airport/airport_runway_medium_sidewalk_border_inner.mtl",
			size = { 32.0, 2.0 }
			
		},
		sidewalkBorderOuter = {
			name = "street/airport/airport_taxiway_medium_sidewalk_border_outer.mtl",
			size = { 32.0, 2.0 }
			
		},
		sidewalkCurb = {
		},
		sidewalkWall = {
		}	
	},
	assets = { },
	cost = 66.0,
}
end
