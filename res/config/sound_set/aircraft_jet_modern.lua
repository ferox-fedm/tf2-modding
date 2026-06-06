local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_modern/_modernjet_idle.wav", 25.0,
		{ { .0, .5 }, { 0.5, 1.0 }, { 1.0, 0.15 } },
		{ { .0, 0.8 }, { 1.0, 1.5 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_modern/_modernjet_flying.wav", 25.0,
		{ { 0.4, .0 }, { 1.0, 1.0 } },
		{ { 0.4, 0.8 }, { 1.0, 1.3} }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_modern/_no-license_A320_CFM56_Turbo_out.wav", 25.0,
		{ { 0.4, .0 }, { 1.0, 1.0 } },
		{ { 0.4, 0.9 }, { 1.0, 1.0} }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_oldjet_distant.wav", 200.0,
		{ { 0.5, 0.0 }, { 0.9, 0.7 } },
		{ { .0, 1.0 } }, "power01")

soundsetutil.addEvent(data, "land", { "vehicle/aircraft_jet_modern/_modernjet_land.wav" }, 25.0)

soundsetutil.addEvent(data, "horn", { 
	"vehicle/aircraft_jet_modern/airplane_horn_01.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_02.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_03.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_04.wav",
}, 15.0)

return data

end
