local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/aircraft_prop_old/_aircraft_prop_old_idle.wav", 25.0,
		{ { 0.0, 0.5 }, { 0.5, 1.0 }, { 1.0, 0.15 } },
		{ { 0.05, 0.8 }, { 1.0, 1.5 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_prop_old/_aircraft_prop_old_power.wav", 25.0,
		{ { 0.3, 0.0 }, { 0.6, 0.9 }, { 1.0, 1.0 } },
		{ { 0.3, 0.8 }, { 0.6, 0.8 }, { 1.0, 1.1 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_prop_old/_aircraft_prop_old_distant.wav", 100.0,
		{ { 0.5, 0.0 }, { 0.9, 0.3 } },
		{ { 0, 1.0 } }, "power01")

soundsetutil.addEvent(data, "land", { "vehicle/aircraft_prop_old/_aircraft_prop_old_land.wav" }, 25.0)

soundsetutil.addEvent(data, "horn", { 
	"vehicle/aircraft_jet_modern/airplane_horn_01.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_02.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_03.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_04.wav",
}, 15.0)

return data

end
