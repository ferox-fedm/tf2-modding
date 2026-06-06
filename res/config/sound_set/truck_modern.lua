local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/truck_modern/idle.wav",
		.075, .6, "vehicle/truck_modern/drive.wav", .4, 18.0, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/truck_modern/horn.wav" }, 18.0)
soundsetutil.addEvent(data, "openDoors", { "vehicle/truck_modern/open_doors.wav" }, 5.0)
soundsetutil.addEvent(data, "closeDoors", { "vehicle/truck_modern/close_doors.wav" }, 5.0)

return data

end
