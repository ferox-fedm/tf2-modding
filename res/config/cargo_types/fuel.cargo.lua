function data()
return 
	{ 
		id = "FUEL", 
		name = _("Fuel"),
		weight = 1200.0,
		order = 15,
		discreteModels = {
			SMALL = "industry/cargo/fuel_small.mdl",
			BIG = "industry/cargo/fuel_big.mdl"
		},
		townInput = {
			"INDUSTRIAL",
		},
	}
end
