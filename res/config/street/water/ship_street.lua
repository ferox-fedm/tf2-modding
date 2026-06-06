function data()
return {
	numLanes = 1,
	streetWidth = 10.0,
	sidewalkWidth = 1.0,
	sidewalkHeight = 0.0,
	yearFrom = 1925,
	yearTo = 0,
	aiLock = true,
	country = false,
	speed = 35.0,
	priority = 1,
	transportModesStreet = { "SMALL_SHIP", "SHIP" },
	transportModesSidewalk = { },
	name = _("Waterway"),
	desc = _("Waterway with a speed limit of %2%."),
	streetFillGroundTex = "none.lua",
	sidewalkFillGroundTex = "none.lua",
	borderGroundTex = "none.lua",
	materials = {
		streetPaving = {
			name = "street/transparent.mtl",
			size = { 8.0, 8.0 }
		},
		streetBorder = {
			name = "street/transparent.mtl",
			size = { 6.0, .5 }
		},		
		sidewalkPaving = {
			name = "street/transparent.mtl",
			size = { 4.0, 4.0 }
		},
		sidewalkBorderInner = {
			name = "street/transparent.mtl",		
			size = { 3, 0.6 }
		},
		sidewalkBorderOuter = {
			name = "street/transparent.mtl",		
			size = { 8.0, 0.41602 }
		},
		sidewalkCurb = {
			name = "street/transparent.mtl",
			size = { 3, .35 }
		},
		sidewalkWall = {
			name = "street/transparent.mtl",
			size = { 8.0, 0.41602 }
		}	

	},
	cost = 66.0,
}
end
