local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/aircraft_prop_modern/_aircraft_prop_mod_idle.wav", 25.0,
		{ { 0, 1 }, { 1, 0 } },
		{ { 0, 1 }, { 1.0, 1.4 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/aircraft_prop_modern/_aircraft_prop_mod_power1.wav", 25.0,
		{ { 0, 0.3 }, { 1.0, 1.0 } },
		{ { 0, 0.9 }, { 1.0, 1.3} }, "power01")

soundsetutil.addEvent(data, "land", { "vehicle/aircraft_prop_modern/_aircraft_prop_mod_land.wav" }, 25.0)

soundsetutil.addEvent(data, "horn", { 
	"vehicle/aircraft_jet_modern/airplane_horn_01.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_02.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_03.wav",
	"vehicle/aircraft_jet_modern/airplane_horn_04.wav",
}, 15.0)

return data

end
