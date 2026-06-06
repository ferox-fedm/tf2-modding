local soundsetutil = require "soundsetutil"

local randomEventNames = {
	"selected_industry_goods_factory1.wav",
	"selected_industry_steel_mill1.wav",
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addTrackParam01(data, "construction/station/Shipyard.wav", 25.0,
		{ { .0, .5 } }, { { .0, 0.7 } }, "cargo01")
		
soundsetutil.addTrackParam01(data, "environment/Industrial_1920.wav", 25.0,
		{ { .0, .0 }, { 1.0, 1.0 } }, { { .0, 1.0 } }, "cargo01")

soundsetutil.addEventParam01(data, "random32", randomEventNames, 50.0,
		{ { .33, 1.0 }, { .34, .0 } }, { { .0, 1.0 } }, "cargo01")
		
soundsetutil.addEventParam01(data, "random16", randomEventNames, 50.0,
		{ { 0.33, 0.0 }, { 0.34, 1.0 }, { 0.66, 1.0 }, { 0.67, 0.0 } }, { { .0, 1.0 } }, "cargo01")
		
soundsetutil.addEventParam01(data, "random8", randomEventNames, 50.0,
		{ { 0.66, 0.0 }, { 0.67, 1.0 } }, { { .0, 1.0 } }, "cargo01")

return data

end
