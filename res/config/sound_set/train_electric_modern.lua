local soundsetutil = require "soundsetutil"

local clackNames = {
	"vehicle/clack/modern/part_1.wav",
	"vehicle/clack/modern/part_2.wav",
	"vehicle/clack/modern/part_3.wav",
	"vehicle/clack/modern/part_4.wav",
	"vehicle/clack/modern/part_5.wav",
	"vehicle/clack/modern/part_6.wav",
	"vehicle/clack/modern/part_7.wav",
	"vehicle/clack/modern/part_8.wav",
	"vehicle/clack/modern/part_9.wav",
	"vehicle/clack/modern/part_10.wav"
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/train_electric_modern/drive.wav", 25.0,
		{ { .0, .0 }, { 1.0, 1.0 } }, { { .0, 1.0 }, { 1.0, 1.15 } }, "speed01")

soundsetutil.addTrackSqueal(data, "vehicle/train/wheels_ringing1.wav", 25.0)
soundsetutil.addTrackBrake(data, "vehicle/train_electric_modern/_brakes.wav", 25.0, .5)

soundsetutil.addEventClacks(data, clackNames, 15.0, 10.0)
soundsetutil.addEvent(data, "horn", { "vehicle/train_electric_modern/horn_11.wav" }, 50.0)

return data

end