local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/car_old/car_old_idle.wav",
		.075, .6, "vehicle/car_old/car_old_drive.wav", .4, 5.0, "speed01")

soundsetutil.addEvent(data, "horn", { "vehicle/car_old/car_old_horn.wav" }, 5.0)

return data

end