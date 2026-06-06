local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/tram_modern/idle.wav", 18.0,
		{ { .0, 1.0 }, { .15, .0 } }, { { .0, 1.0 } }, "speed01")

soundsetutil.addTrackParam01(data, "vehicle/tram_modern/drive.wav", 18.0,
		{ { .0, .0 }, { .15, 1.0 } }, { { .0, .94 }, { .15, 1.0 }, { .28, 1.06 }, { .53, 1.12 }, { 1.0, 1.19 } }, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/tram_modern/bell.wav" }, 30.0)
--soundsetutil.addEvent(data, "openDoors", { "vehicle/bus_modern/bus_modern_open_door.wav" }, 5.0)
--soundsetutil.addEvent(data, "closeDoors", { "vehicle/bus_modern/bus_modern_close_door.wav" }, 5.0)

return data

end
