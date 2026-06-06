local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_no-license_xJT8D15_front.wav", 25.0,
		{ { .0, .5 }, { 0.5, 0.8 }, { 1.0, 0.2} },
		{ { .0, 0.9 }, { 1.0, 1.6 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_no-license_xJT8D15_front_2.wav", 25.0,
		{ { .0, .5 }, { 0.5, 0.8 }, { 1.0, 0.2} },
		{ { .0, 0.95 }, { 1.0, 1.55 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_no-license_xJT8D_Blast.wav", 25.0,
		{ { 0.5, 0.0 }, { 1.0, 1.0 } },
		{ { 0.0, 1.0 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_oldjet_fan.wav", 25.0,
		{ { 0.0, 0.0 }, { 1.0, 1.0 } },
		{ { 0.0, 0.8 }, { 1.0, 1.1 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_jet_old/_oldjet_distant.wav", 400.0,
		{ { 0.5, 0.0 }, { 1.0, 0.7 } },
		{ { .0, 1.0 } }, "power01")

soundsetutil.addEvent(data, "land", { "vehicle/aircraft_jet_old/_oldjet_land.wav" }, 25.0)

soundsetutil.addEvent(data, "horn", { 
	"vehicle/aircraft_jet_modern/airplane_horn_01.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_02.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_03.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_04.wav",
}, 15.0)

return data

end
