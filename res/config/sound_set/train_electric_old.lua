local audioutil = require "audioutil"
local soundsetutil = require "soundsetutil"

local clackNames = {
	"vehicle/clack/old/part_1.wav",
	"vehicle/clack/old/part_2.wav",
	"vehicle/clack/old/part_3.wav",
	"vehicle/clack/old/part_4.wav",
	"vehicle/clack/old/part_5.wav",
	"vehicle/clack/old/part_6.wav",
	"vehicle/clack/old/part_7.wav",
	"vehicle/clack/old/part_8.wav",
	"vehicle/clack/old/part_9.wav",
	"vehicle/clack/old/part_10.wav"
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/train_electric_old/drive.wav", 25.0,
		audioutil.plotSqrt(.0, .1, 1.0, 1.0, 10), { { .0, 1.0 }, { 1.0, 1.33 } }, "speed01")

soundsetutil.addTrackSqueal(data, "vehicle/train/wheels_ringing1.wav", 25.0)
soundsetutil.addTrackBrake(data, "vehicle/train_electric_old/_brakes.wav", 25.0, .5)

soundsetutil.addEventClacks(data, clackNames, 15.0, 10.0)
soundsetutil.addEvent(data, "horn", { "vehicle/train_electric_old/whistle2.wav" }, 50.0)

return data

end
