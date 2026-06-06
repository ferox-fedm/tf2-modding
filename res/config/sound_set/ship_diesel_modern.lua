local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_modern/_ship_diesel_modern_engines.wav", 25.0,
		{ { 0.0, 0.8 }, { 1.0, 1.0 } },
		{ { 0.05, 0.8 }, { 1.0, 1.1 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_modern/_ship_diesel_modern_wake.wav", 25.0,
		{ { 0.0, 0.0 }, { 1.0, 0.5 } },
		{ { 0.0, 0.8 }, { 1.0, 1.0 } }, "speed01")
			
soundsetutil.addEvent(data, "horn", { "vehicle/ship_diesel_modern/_ship_diesel_modern_horn.wav" }, 50.0)

return data

end