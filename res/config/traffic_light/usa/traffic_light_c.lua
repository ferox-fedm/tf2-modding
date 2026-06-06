local trafficlightutil = require "trafficlightutil"

function data()
	local input = {
		models = {
			trafficLightPole = "street/traffic_light_us_c/pole.mdl",
			pedestrianPole = "street/traffic_light_us_c/pedestrian_pole.mdl",
			beam = {
				"street/traffic_light_us_c/beam_1.mdl",
				"street/traffic_light_us_c/beam_2.mdl",
				"street/traffic_light_us_c/beam_r.mdl",
				-- last model is repeated
			},
			trafficLight = {
				"street/traffic_light_us_c/traffic_light_1.mdl",
				"street/traffic_light_us_c/traffic_light_r.mdl",
				-- last model is repeated
			},
			pedestrianLight = "street/traffic_light_us_c/pedestrian_light.mdl",
		},
		params = {
			offset = -0.25,
			beamWidth = { 4 + .25, 4, 4 }, -- on model repetition last entry is used
			lightOffset = { 2, 2 }, -- offset is relative to beam -- on model repetition last entry is used
			poleTrafficLight = false
		}
	}

	return {
		yearFrom = 1980,
		tryOpposite = true,
		modelFn = trafficlightutil.standardLights(input),
	}
end
