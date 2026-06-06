function data()
return {
	name = _("Modern Half-barrier crossing"),
	soundFileName = "railroad_crossing.wav",
	config = {
		{ modelLeft = "railroad/crossing/us_a_simple.mdl", modelRight = "railroad/crossing/us_c_barrier_small.mdl", streetWidth = 12.0 },
		{ modelLeft = "railroad/crossing/us_a_simple.mdl", modelRight = "railroad/crossing/us_c_barrier_small.mdl", streetWidth = 18.0 },
		{ modelLeft = "railroad/crossing/us_a_simple.mdl", modelRight = "railroad/crossing/us_c_barrier_medium.mdl", streetWidth = 22.0 },
		{ modelLeft = "railroad/crossing/us_a_simple.mdl", modelRight = "railroad/crossing/us_c_barrier_large.mdl", streetWidth = 28.0 },
	},
	speedLimit = 160.0 / 3.6,
	yearFrom = 1975,
	cost = 16000,
	trafficDelay = 2500,
}
end
