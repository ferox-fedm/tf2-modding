local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/bus_modern/bus_modern_idle.wav",
		.075, .6, "vehicle/bus_modern/bus_modern_drive.wav", .4, 18.0, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/bus_modern/bus_modern_horn.wav" }, 18.0)
soundsetutil.addEvent(data, "openDoors", { "vehicle/bus_modern/bus_modern_open_door.wav" }, 5.0)
soundsetutil.addEvent(data, "closeDoors", { "vehicle/bus_modern/bus_modern_close_door.wav" }, 5.0)

return data

end
