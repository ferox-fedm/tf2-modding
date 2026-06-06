function data()
return {
	name = _("Simple crossing"),
	config = {
		--{ model = "railroad/signal_crossing_old.mdl", streetWidth = 0.0 }
		--{ modelLeft = "railroad/signal_crossing_old.mdl", modelRight = "railroad/signal_crossing_old.mdl" }
		{ modelRight = "railroad/crossing_simple.mdl" }
	},
	speedLimit = 120.0 / 3.6,
	yearFrom = -1,
	yearTo = -1,
	cost = 4000,
}
end
