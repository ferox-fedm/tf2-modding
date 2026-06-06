function data()
return {
	name = _("Half-barrier crossing"),
	config = {
		{ modelLeft = "railroad/crossing_light_only.mdl", modelRight = "railroad/crossing_half_barrier_small.mdl", streetWidth = 12.0 },
		{ modelLeft = "railroad/crossing_light_only.mdl", modelRight = "railroad/crossing_half_barrier_medium.mdl", streetWidth = 18.0 },
		{ modelLeft = "railroad/crossing_light_only.mdl", modelRight = "railroad/crossing_half_barrier_large.mdl", streetWidth = 22.0 }
	},
	speedLimit = 160.0 / 3.6,
	yearFrom = -1,
	yearTo = -1,
	cost = 16000,
}
end
