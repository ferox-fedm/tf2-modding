local trafficlightutil = require "trafficlightutil"

function data()
	local input = {
		models = {
			trafficLightPole = "street/traffic_light_eu_a/pole.mdl",
			pedestrianPole = "street/traffic_light_eu_a/pedestrian_pole.mdl",
			beam = {
				"street/traffic_light_eu_a/beam_1.mdl",
				"street/traffic_light_eu_a/beam_r.mdl",
				-- last model is repeated
			},
			trafficLight = {
				"street/traffic_light_eu_a/traffic_light_1.mdl",
				"street/traffic_light_eu_a/traffic_light_r.mdl",
				-- last model is repeated
			},
			pedestrianLight = "street/traffic_light_eu_a/pedestrian_light.mdl",
		},
		params = {
			offset = -0.25,
			beamWidth = { 6 + .25, 3 }, -- on model repetition last entry is used
			lightOffset = { 4.5, 1.5 }, -- offset is relative to beam -- on model repetition last entry is used
			poleTrafficLight = true
		}
	}

	return {
		yearFrom = 1912,
		tryOpposite = false,
		modelFn = trafficlightutil.standardLights(input),
	}
end
