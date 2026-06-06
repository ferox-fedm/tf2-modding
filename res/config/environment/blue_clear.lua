local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { .945, .0037, .328 },
			pmremShadow = "environment/blue_clear/shadow.dds",
			pmremSun = "environment/blue_clear/sun.dds",
			refBrightness = .5
		},
		
		atmosphere = {
			sunColor = { 1.147, .952, .681 },
			rayleightExtinctionCoeff = environmentutil.rayleighExtinctionCoeff(2.0),
			mieScatteringCoeff = environmentutil.mieScatteringCoeff(2.0),
			phaseG = -.6,
			rayleightScaleHeight = 280.0,
			mieScaleHeight = 250.0
		},
		
		water = {
			normalTex = "environment/water_normal.dds",
			normalScale = .4,
			roughness = .5,
			
			depthColorTex = "environment/blue_clear/depthColor.dds",
			extinctionCoeff = .05
		},

		skyBox = {
			texture = "environment/blue_clear/skybox.dds",
		}
	}
end
