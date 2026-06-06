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
			normalScale = .6,
			roughness = 1.0,
			
			depthColorTex = "environment/campain/mission_1/depthColor_mission_1.dds",
			extinctionCoeff = .050,
			
		},

		skyBox = {
			texture = "environment/desert/skybox.dds",
		}
	}
end
