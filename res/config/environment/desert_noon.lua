local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { .466, -.417, .780 },
			pmremShadow = "environment/desert_noon/shadow.dds",
			pmremSun = "environment/desert_noon/sun.dds",
			refBrightness = .4
		},
		
		atmosphere = {
			sunColor = { .938, .969, 1.048 },
			rayleightExtinctionCoeff = environmentutil.rayleighExtinctionCoeff(3.0),
			mieScatteringCoeff = environmentutil.mieScatteringCoeff(1.0),
			phaseG = -.75,
			rayleightScaleHeight = 280.0,
			mieScaleHeight = 200.0
		},
		
		water = {
			normalTex = "environment/water_normal.dds",
			normalScale = .3,
			preferLowFreq = true,
			roughness = .0,
			
			depthColorTex = "environment/desert_noon/depthColor.dds",
			extinctionCoeff = .1
		},

		skyBox = {
			texture = "environment/desert_noon/skybox.dds",
		}
	}
end
