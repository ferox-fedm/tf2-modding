local environmentutil = require "environmentutil"

function data()
	return {
		light = {
			direction = { math.cos(math.rad(60.0)), math.sin(math.rad(60.0)), math.tan(math.rad(50.0)) },
			pmremShadow = "environment/default/shadow.dds",
			pmremSun = "environment/default/sun.dds",
			refBrightness = 2.0
		},
		
		atmosphere = {
			sunColor = { 1.047, .999, .697 },
			rayleightExtinctionCoeff = environmentutil.rayleighExtinctionCoeff(3.0),
			mieScatteringCoeff = environmentutil.mieScatteringCoeff(1.0),
			phaseG = -.75,
			rayleightScaleHeight = 280.0,
			mieScaleHeight = 200.0
		},
		
		water = {
			normalTex = "environment/water_normal.dds",
			normalScale = .4,
			roughness = .5,
			
			depthColorTex = "environment/default/depthColor.dds",
			extinctionCoeff = .2
		},

		skyBox = {
			texture = "environment/default/skybox.dds",
		}
	}
end
