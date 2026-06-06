local soundsetutil = require "soundsetutil"

local randomEventNames = {
	"environment/cc_airport_announc01.wav",
	"environment/cc_airport_announc02.wav",
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "construction/station/airport_1920.wav", 100.0,
		{ { .0, .05 } }, { { .0, 1.0 } }, "crowd01")

soundsetutil.addTrackParam01(data, "environment/Crowd_large.wav", 25.0,
		{ { 0.0, 0.1 }, { 1.0, 1.0 } }, { { .0, 1.0 } }, "crowd01")

soundsetutil.addEventParam01(data, "random32", randomEventNames, 50.0,
		{ { .33, 1.0 }, { .34, .0 } }, { { .0, 1.0 } }, "crowd01")
		
soundsetutil.addEventParam01(data, "random16", randomEventNames, 50.0,
		{ { 0.33, 0.0 }, { 0.34, 1.0 }, { 0.66, 1.0 }, { 0.67, 0.0 } }, { { .0, 1.0 } }, "crowd01")
		
soundsetutil.addEventParam01(data, "random8", randomEventNames, 50.0,
		{ { 0.66, 0.0 }, { 0.67, 1.0 } }, { { .0, 1.0 } }, "crowd01")

return data

end
