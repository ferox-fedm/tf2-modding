local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/ship_hovercraft/_ship_hovercraft_idle.wav", 5.0,
		{ { 0.0, 1.0 }, { 1.0, 0.0 } },
		{ { 0.0, 0.8 }, { 1.0, 1.1 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/ship_hovercraft/_ship_hovercraft_power.wav", 5.0,
		{ { 0.0, 0.0 }, { 1.0, 1.0 } },
		{ { 0.0, 0.8 }, { 1.0, 1.0 } }, "power01")
soundsetutil.addEvent(data, "horn", { "vehicle/ship_hovercraft/_ship_hovercraft_horn.wav" }, 50.0)

return data

end
