local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/tram_old/drive.wav", 18.0,
		{ { .0, .0 }, { .1, .32 }, { .3, .55 }, { .6, .77 }, { 1.0, 1.0 } }, { { .0, 1.0 } }, "speed01")
		
soundsetutil.addEvent(data, "openDoors", { "vehicle/tram_old/bell.wav" }, 5.0)
soundsetutil.addEvent(data, "closeDoors", { "vehicle/truck_modern/close_doors.wav" }, 5.0)
soundsetutil.addEvent(data, "horn", { "vehicle/tram_old/bell3.wav" }, 30.0)

return data

end
