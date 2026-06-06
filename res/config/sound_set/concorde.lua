local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/concorde/_concorde_idle.wav", 25.0,
		{ { 0.05, 1.0 }, { 0.3, 0.0 } },
		{ { 0.0, 1.0 }, { 0.3, 1.5 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/concorde/_concorde_idle_power2.wav", 25.0,
		{ { 0.05, 0.5 }, { 0.7, 0.0 } },
		{ { 0.0, 1.0 }, { 0.7, 1.5 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/concorde/_no-license_xolympus593_spool_distant.wav", 25.0,
		{ { 0.0, 0.0 }, { 0.05, 1.0 }, { 0.9, 0.3 } },
		{ { 0.0, 0.8 }, { 0.9, 1.5 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/concorde/_concorde_boost.wav", 25.0,
		{ { 0, 0.0 }, { 1.0, 1.0 } },
		{ { 0.0, 1 }, { 1, 1.2 } }, "power01")
		
soundsetutil.addTrackParam01(data, "vehicle/concorde/_concorde_distant.wav", 1000.0,
		{ { 0.5, 0.0 }, { 0.9, 1.0 } },
		{ { .0, 1.0 } }, "power01")

soundsetutil.addEvent(data, "sonicBoom", { "vehicle/concorde/sonic_boom.wav" }, 750.0)
soundsetutil.addEvent(data, "land", { "vehicle/concorde/_concorde_land.wav" }, 25.0)

return data

end
