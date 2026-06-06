local audioutil = require "audioutil"

local soundsetutil = { }

local function squeal(track, speed, sideForce, maxSideForce)
	local gain = 0.0
	
	local speedGain = math.mapClamp(speed, 20.0, 40.0, 1.0, 0.0)
	
	local diff = math.max(maxSideForce - sideForce, 0.0)
	gain = math.min(math.max(1.0 - 2.0 * diff, 0.0), 1.0)

	track.gain = gain * speedGain
	track.pitch = 1.0
end

local function clacks(event, speed, weight, numAxles, axleRefWeight, gameSpeedUp)
	local speedupGain = 0.5
	if gameSpeedUp <= 2.0 then speedupGain = 0.707 end
	if gameSpeedUp <= 1.0 then speedupGain = 1.0 end
	
	local axleWeight = weight / numAxles
	local axleWeightGain = math.min(axleWeight / axleRefWeight, 1.0)
	local axleWeightGain2 = math.sqrt(axleWeightGain)
	local gain = math.mapClamp(speed, 0.0, 10.0, 0.25, 1.0)
	local pitch = math.mapClamp(weight, 10.0, 100.0, 1.0, 0.5)
	
	event.gain = gain * axleWeightGain2 * speedupGain
	event.pitch = pitch
end

local function brake(track, speed, brakeDecel, maxGain)
	local gain = 0.0
	if 0.1 < brakeDecel then
		local maxBrakeDecel = 5.0
		local brakeGain = math.sqrt(math.min(brakeDecel / maxBrakeDecel))
		local speed0 = 1.0
		local speed1 = 2.0 * (brakeGain + 1.0)
		local speed2 = 4.0 * (brakeGain + 1.0)
		local speedFadeIn = math.mapClamp(speed, speed1, speed2, 1.0, 0.0)
		local speedFadeOut = math.mapClamp(speed, 0.0, speed0, 0.0, 1.0)
		gain = speedFadeIn * speedFadeOut * brakeGain * maxGain
	end
	
	track.gain = gain
	track.pitch = 1.0
end

local function chuffs(idleTrack, fastTrack, event, speed, chuffStep, chuffsFastFreq, weight, refWeight)
	local fastSpeed = chuffStep * chuffsFastFreq
	local transitionSpeed = 0.8 * fastSpeed
	local fastSpeed0 = 0.85 * transitionSpeed
	local fastSpeed1 = 1.15 * transitionSpeed
	local fastGain = math.mapClamp(speed, fastSpeed0, fastSpeed1, 0.0, 1.0)
	local gain = math.mapClamp(speed, 0.0, fastSpeed0, 1.0, 0.5) * (1.0 - fastGain)
	local pitch = 1.0
	
	local weightGain = math.min(weight / refWeight, 1.0)
	local weightGain2 = math.sqrt(weightGain)

	idleTrack.gain = gain * weightGain2
	idleTrack.pitch = pitch
	
	fastTrack.gain = fastGain * weightGain2
	fastTrack.pitch = math.sqrt(speed / fastSpeed)
	
	event.gain = gain * weightGain2
	event.pitch = 1.0
end

function soundsetutil.makeSoundSet()
	local updateFns = { }
	local result = { tracks = { }, events = { } }

	local data = {
		tracks = { },
		events = { },
		updateFn = function (input)
			for i = 1, #updateFns do
				updateFns[i](input)
			end
			return result
		end,

		-- internal usage
		updateFns = updateFns,
		result = result
	}

	return data
end

function soundsetutil.addTrack(data, name, refDist, updateFn)
	data.tracks[#data.tracks + 1] = { name = name, refDist = refDist }

	local track = { gain = 1.0, pitch = 1.0 }
	data.result.tracks[#data.result.tracks + 1] = track

	data.updateFns[#data.updateFns + 1] = function (input)
		updateFn(track, input)
	end
end

function soundsetutil.addEvent(data, key, names, refDist, updateFn)
	data.events[key] = { names = names, refDist = refDist }
	
	local event = { gain = 1.0, pitch = 1.0 }
	data.result.events[key] = event
	
	if updateFn then
		data.updateFns[#data.updateFns + 1] = function (input)
			updateFn(event, input)
		end
	end
end


function soundsetutil.addTrackParam01(data, name, refDist, gainCurve, pitchCurve, param01)
	soundsetutil.addTrack(data, name, refDist,
			function (track, input)
				track.gain = audioutil.sampleCurve(gainCurve, input[param01])
				track.pitch = audioutil.sampleCurve(pitchCurve, input[param01])
			end)
end

function soundsetutil.addSimpleTrackParam01(data, name, refDist, param01)
	local gainCurve = { { .0, .0 }, { 1.0, 1.0 } }

	soundsetutil.addTrack(data, name, refDist,
			function (track, input)
				track.gain = audioutil.sampleCurve(gainCurve, input[param01])
			end)
end

function soundsetutil.addEventParam01(data, key, names, refDist, gainCurve, pitchCurve, param01)
	soundsetutil.addEvent(data, key, names, refDist,
			function (event, input)
				event.gain = audioutil.sampleCurve(gainCurve, input[param01])
				event.pitch = audioutil.sampleCurve(pitchCurve, input[param01])
			end)
end

function soundsetutil.addTrackSqueal(data, name, refDist)
	soundsetutil.addTrack(data, name, refDist,
			function (track, input)
				squeal(track, input.speed, input.sideForce, input.maxSideForce)
			end)
end

function soundsetutil.addTrackBrake(data, name, refDist, maxGain)
	soundsetutil.addTrack(data, name, refDist,
			function (track, input)
				brake(track, input.speed, input.brakeDecel, maxGain)
			end)
end

function soundsetutil.addEventClacks(data, names, refDist, axleRefWeight)
	soundsetutil.addEvent(data, "clacks", names, refDist,
			function (event, input)
				clacks(event, input.speed, input.weight, input.numAxles, axleRefWeight, input.gameSpeedUp)
			end)
end

function soundsetutil.makeRoadVehicle2(data, speeds, idle, idleSpeed, idleGain0, drive, driveSpeed, refDist, param01)
	local gainCurve1 = {
		{ .0, idleGain0 },
		{ speeds[1], 1.0 },
		{ speeds[2], 1.0 },
		{ speeds[3], .0 },
	}

	local pitchCurve1 = audioutil.plotSqrtY(idleSpeed, .8, 1.25)

	local gainCurve2 = {
		{ speeds[2], .0 },
		{ speeds[3], 1.0 },
	}

	local pitchCurve2 = audioutil.plotSqrtY(driveSpeed, .8, 1.5)

	soundsetutil.addTrackParam01(data, idle, refDist, gainCurve1, pitchCurve1, param01)
	soundsetutil.addTrackParam01(data, drive, refDist, gainCurve2, pitchCurve2, param01)
end

function soundsetutil.makeSteamTrain(data, idle, fast, tracksRefDist, chuffNames, chuffsRefDist, chuffsFastFreq, refWeight)
	data.tracks[#data.tracks + 1] = { name = idle, refDist = tracksRefDist }
	data.tracks[#data.tracks + 1] = { name = fast, refDist = tracksRefDist }

	local idleTrack = { gain = 1.0, pitch = 1.0 }
	local fastTrack = { gain = 1.0, pitch = 1.0 }
	
	data.result.tracks[#data.result.tracks + 1] = idleTrack
	data.result.tracks[#data.result.tracks + 1] = fastTrack
	
	data.events["chuffs"] = { names = chuffNames, refDist = chuffsRefDist }
	
	local chuffEvent = { gain = 1.0, pitch = 1.0 }
	
	data.result.events["chuffs"] = chuffEvent

	data.updateFns[#data.updateFns + 1] = function (input)
		chuffs(idleTrack, fastTrack, chuffEvent, input.speed, input.chuffStep, chuffsFastFreq, input.weight, refWeight)
	end
end

return soundsetutil
