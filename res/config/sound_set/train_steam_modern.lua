local soundsetutil = require "soundsetutil"

local chuffNames = {
	"vehicle/train_steam_modern/steam_new_chuff_1.wav",
	"vehicle/train_steam_modern/steam_new_chuff_2.wav",
	"vehicle/train_steam_modern/steam_new_chuff_3.wav",
	"vehicle/train_steam_modern/steam_new_chuff_4.wav",
	"vehicle/train_steam_modern/steam_new_chuff_5.wav",
	"vehicle/train_steam_modern/steam_new_chuff_6.wav",
	"vehicle/train_steam_modern/steam_new_chuff_7.wav",
	"vehicle/train_steam_modern/steam_new_chuff_8.wav",
	"vehicle/train_steam_modern/steam_new_chuff_9.wav",
	"vehicle/train_steam_modern/steam_new_chuff_10.wav"
}

function data()

local data = soundsetutil.makeSoundSet()

soundsetutil.makeSteamTrain(data, "vehicle/train_steam_modern/steam_new_idle.wav",
		"vehicle/train_steam_modern/steam_new_fast.wav", 25.0, chuffNames, 15.0, 12.0, 90.0)

soundsetutil.addTrackSqueal(data, "vehicle/train/wheels_ringing1.wav", 25.0)
soundsetutil.addTrackBrake(data, "vehicle/train_steam_modern/_brakes.wav", 25.0, .5)

soundsetutil.addEvent(data, "horn", { "vehicle/train_steam_modern/steam_new_horn.wav" }, 50.0)

return data

end