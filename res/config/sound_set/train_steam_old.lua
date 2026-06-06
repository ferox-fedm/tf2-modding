local soundsetutil = require "soundsetutil"

local chuffNames = {
	"vehicle/train_steam_old/chuff_1.wav",
	"vehicle/train_steam_old/chuff_2.wav",
	"vehicle/train_steam_old/chuff_3.wav",
	"vehicle/train_steam_old/chuff_4.wav",
	"vehicle/train_steam_old/chuff_5.wav",
	"vehicle/train_steam_old/chuff_6.wav",
	"vehicle/train_steam_old/chuff_7.wav",
	"vehicle/train_steam_old/chuff_8.wav",
	"vehicle/train_steam_old/chuff_9.wav",
	"vehicle/train_steam_old/chuff_10.wav"
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeSteamTrain(data, "vehicle/train_steam_old/idle.wav",
		"vehicle/train_steam_old/fast.wav", 25.0, chuffNames, 15.0, 12.0, 45.0)

soundsetutil.addTrackSqueal(data, "vehicle/train/wheels_ringing1.wav", 25.0)
soundsetutil.addTrackBrake(data, "vehicle/train_steam_old/_brakes.wav", 25.0, .5)

soundsetutil.addEvent(data, "horn", { "vehicle/train_steam_old/horn.wav" }, 50.0)

return data

end