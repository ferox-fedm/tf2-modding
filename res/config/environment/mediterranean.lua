local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { .660, .0029, .751 },
			pmremShadow = "environment/temperate/shadow.dds",
			pmremSun = "environment/temperate/sun.dds",
			refBrightness = .5
		},
		
		atmosphere = {
			sunColor = { 1.048, .961, .851 },
			rayleightExtinctionCoeff = environmentutil.rayleighExtinctionCoeff(3.0),
			mieScatteringCoeff = environmentutil.mieScatteringCoeff(1.0),
			phaseG = -.75,
			rayleightScaleHeight = 280.0,
			mieScaleHeight = 200.0
		},
		
		water = {
			normalTex = "environment/water_normal.dds",
			normalScale = .6,
			roughness = 1.0,
			
			depthColorTex = "environment/tropical/depthColor.dds",
			extinctionCoeff = .05,
			
			waveFoamTex = "environment/water_wave_foam.dds",
		},

		skyBox = {
			texture = "environment/temperate/skybox.dds",
		},
		skyRotation = .0,
	}
end
