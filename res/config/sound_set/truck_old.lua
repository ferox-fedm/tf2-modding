local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/truck_old/truck_old_idle.wav",
		.075, .6, "vehicle/truck_old/truck_old_drive.wav", .4, 18.0, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/truck_old/truck_old_horn.wav" }, 18.0)
soundsetutil.addEvent(data, "openDoors", { "vehicle/truck_old/truck_old_dooropen.wav" }, 5.0)
soundsetutil.addEvent(data, "closeDoors", { "vehicle/truck_old/truck_old_doorclose.wav" }, 5.0)

return data

end
