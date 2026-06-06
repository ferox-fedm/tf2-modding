local soundsetutil = require "soundsetutil"

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.addSimpleTrackParam01(data, "environment/Construction_Site3.wav", 5.0, "underConstruction")

return data

end