local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "vehicle/carriage/drive.wav", 18.0,
		{ { .0, .0 }, { .5, .8 }, { 1.0, 1.0 } },
		{ { .0, .8 }, { .5, 1.0 }, { 1.0, 1.2 } }, "speed01")

soundsetutil.addEvent(data, "horn", { 
	"vehicle/carriage/coach_horn_01.wav",
	"vehicle/carriage/coach_horn_02.wav",
	"vehicle/carriage/coach_horn_03.wav",
}, 10.0)

return data

end
 