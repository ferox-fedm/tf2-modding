local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_old/_ship_diesel_old_drive.wav", 25.0,
		{ { 0.0, 0.0 }, { 0.025, 0.5 }, { 1.0, 1 } },
		{ { 0.05, 0.6 }, { 1.0, 1.0 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/ship_steamer/_ship_steamer_idle.wav", 25.0,
		{ { 0.0, 0.4 }, { 0.2, 0.0 } },
		{ { 0.0, 1.0 }, { 1.0, 1.0 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/ship_steamer/_ship_steamer_fullpower.wav", 5.0,
		{ { 0.3, 0.0 }, { 1.0, 1.0 } },
		{ { 0.0, 0.9 }, { 1.0, 1.0 } }, "speed01")

soundsetutil.addTrackParam01(data, "vehicle/ship_steamer/_ship_steamer_wake.wav", 5.0,
		{ { 0.0, 0.0 }, { 1.0, 0.6 } },
		{ { 0.0, 0.8 }, { 1.0, 1.0 } }, "speed01")
		
soundsetutil.addEvent(data, "horn", { "vehicle/ship_steamer/_ship_steamer_horn.wav" }, 50.0)

return data

end
