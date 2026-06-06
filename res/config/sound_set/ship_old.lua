local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeRoadVehicle2(data, { .05, .1, .3 }, "vehicle/truck_modern/idle.wav",
		.075, .6, "vehicle/truck_modern/drive.wav", .4, 25.0, "power01")


return data

end