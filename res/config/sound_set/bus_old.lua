local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/bus_old/bus_old_idle.wav",
		.075, .6, "vehicle/bus_old/bus_old_drive.wav", .4, 18.0, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/bus_old/bus_old_horn.wav" }, 18.0)
soundsetutil.addEvent(data, "openDoors", { "vehicle/bus_old/bus_old_open_door.wav" }, 5.0)
soundsetutil.addEvent(data, "closeDoors", { "vehicle/bus_old/bus_old_close_door.wav" }, 5.0)

return data

end
