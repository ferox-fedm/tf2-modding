local trafficlightutil = require "trafficlightutil"

function data()
	local input = {
		models = {
			trafficLightPole = "street/traffic_light_us_a/pole.mdl",
			pedestrianPole = "street/traffic_light_us_a/pedestrian_pole.mdl",
			beam = {
				"street/traffic_light_us_a/beam_1.mdl",
				"street/traffic_light_us_a/beam_r.mdl",
				-- last model is repeated
			},
			trafficLight = {
				"street/traffic_light_us_a/traffic_light_1.mdl",
				"street/traffic_light_us_a/traffic_light_r.mdl",
				-- last model is repeated
			},
			pedestrianLight = "street/traffic_light_us_a/pedestrian_light.mdl",
		},
		params = {
			offset = -0.25,
			beamWidth = { 4 + .25, 4 }, -- on model repetition last entry is used
			lightOffset = { 2, 2 }, -- offset is relative to beam -- on model repetition last entry is used
			poleTrafficLight = false
		}
	}

	return {
		yearFrom = 1912,
		tryOpposite = true,
		modelFn = trafficlightutil.standardLights(input),
	}
end
