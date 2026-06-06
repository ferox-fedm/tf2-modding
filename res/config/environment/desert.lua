local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { .537, -.0033, .844 },
			pmremShadow = "environment/desert/shadow.dds",
			pmremSun = "environment/desert/sun.dds",
			refBrightness = .33
		},
		
		atmosphere = {
			sunColor = { 1.150, .958, .652 },
			rayleightExtinctionCoeff = environmentutil.rayleighExtinctionCoeff(8.0),
			mieScatteringCoeff = environmentutil.mieScatteringCoeff(10.0),
			phaseG = -.75,
			rayleightScaleHeight = 280.0,
			mieScaleHeight = 200.0
		},
		
		water = {
			normalTex = "environment/water_normal.dds",
			normalScale = .3,
			preferLowFreq = true,
			roughness = .0,
			
			depthColorTex = "environment/desert/depthColor.dds",
			extinctionCoeff = .1
		},

		skyBox = {
			texture = "environment/desert/skybox.dds",
		}
	}
end
