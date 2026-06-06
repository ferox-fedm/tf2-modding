local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addSimpleTrackParam01(data, "construction/industry/farm.wav", 25.0, "production01")

return data

end