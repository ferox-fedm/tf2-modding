local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_old/_ship_diesel_old_idle.wav", 25.0,
		{ { 0.0, 1 }, { 1.0, 0 } },
		{ { 0.0, 0.9 }, { 1.0, 1 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_old/_ship_diesel_old_drive.wav", 25.0,
		{ { 0.0, 0.0 }, { 1.0, 1 } },
		{ { 0.0, 0.9 }, { 1.0, 1.0 } }, "speed01")

soundsetutil.addTrackParam01(data, "vehicle/ship_diesel_old/_ship_diesel_old_distant.wav", 500.0,
		{ { 0.5, 0 }, { 1.0, 1 } },
		{ { 0.0, 1 }, { 1.0, 1.0 } }, "speed01")
		
soundsetutil.addEvent(data, "horn", { "vehicle/ship_hovercraft/_ship_hovercraft_horn.wav" }, 50.0)

return data

end
