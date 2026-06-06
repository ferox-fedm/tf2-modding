local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { .826, .0032, .564 },
			pmremShadow = "environment/tropical/shadow.dds",
			pmremSun = "environment/tropical/sun.dds",
			refBrightness = 1.0
		},
		
		atmosphere = {
			sunColor = { 1.058, .958, .840 },
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
			texture = "environment/tropical/skybox.dds",
		}
	}
end
