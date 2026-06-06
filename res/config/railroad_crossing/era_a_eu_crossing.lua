function data()
return {
	name = _("Simple crossing"),
	soundFileName = "railroad_crossing.wav",
	config = {
		--{ model = "railroad/signal_crossing_old.mdl", streetWidth = 0.0 }
		--{ modelLeft = "railroad/signal_crossing_old.mdl", modelRight = "railroad/signal_crossing_old.mdl" }
		{ modelRight = "railroad/crossing/eu_a_simple.mdl" }
	},
	speedLimit = 120.0 / 3.6,
	yearFrom = 1850,
	yearTo = 1925,
	cost = 4000,
}
end
