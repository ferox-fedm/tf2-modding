local transf = require "transf"
local vec3 = require "vec3"

local trafficlightutil = { }

local function streetWidth(widths)
	local w = 0
	for i = 2, #widths - 1 do
		w = w + widths[i]
	end
	return w
end

local function leftHandTraffic(args)
	local n = #args.widths
	local mid = math.ceil(n / 2)
	local leftmatch = 0
	local rightmatch = 0
	for i = 1, n do
		if not args.pedestrian[i] then
			if args.needsLight[i] == (i <= mid) then
				rightmatch = rightmatch + 1
			else
				leftmatch = leftmatch + 1
			end
		end
	end
	return leftmatch > rightmatch
end

local function isOneWay(args)
	for i = 1, #args.needsLight do
		if not args.needsLight[i] and not args.pedestrian[i] then
			return false
		end
	end
	return true
end

local function splitLeftRight(args)
	local n = #args.widths
	local mid = math.ceil(n / 2)
	if isOneWay(args) and not args.oppositePosition then
		return { left = n - mid, right = mid }
	else
		if leftHandTraffic(args) then
			return { left = n - 1, right = 1 }
		else
			return { left = 1, right = n - 1 }
		end
	end
end

local function split2FromTo(split, right)
	if right then
		return { from = 1, to = split.right, inc = 1 }
	else
		return { from = split.right + split.left, to = split.right + 1, inc = -1 }
	end
end

local function getPositions(args)
	local wRight = args.widths[1]
	local wLeft = wRight + streetWidth(args.widths)
	local posRight = transf.mul(args.position, transf.transl(vec3.new(0, -wRight, 0)))
	local posLeft  = transf.mul(args.position, transf.transl(vec3.new(0, -wLeft , 0)))

	local wRightOpp
	local wLeftOpp
	local posRightTraffic = posRight
	local posLeftTraffic = posLeft
	if args.oppositePosition then
		wRightOpp = args.oppositeWidths[1]
		wLeftOpp  =	wRightOpp + streetWidth(args.oppositeWidths)
		posRightTraffic = transf.mul(args.oppositePosition, transf.transl(vec3.new(0, -wRightOpp, 0)))
		posLeftTraffic  = transf.mul(args.oppositePosition, transf.transl(vec3.new(0, -wLeftOpp , 0)))
	end

	return {
		right = {
			pedestrian = posRight,
			traffic = posRightTraffic,
		},
		left = {
			pedestrian = posLeft,
			traffic = posLeftTraffic,
		},
	}
end

local function getFrameOffsets(args, params, count)
	local offsets
	if params.poleTrafficLight == true then
		offsets = { 0, 0, 0 } -- pedestrian, pole, first beam
	else
		offsets = { 0, 0 } -- pedestrian, first beam
	end
	local beamIdx = 1
	for i = #offsets + 1, count do
		offsets[i] = offsets[#offsets] + params.beamWidth[beamIdx]
		beamIdx = math.min(beamIdx + 1, #params.beamWidth)
	end
	return offsets
end

local function getLightOffsets(args, params, count, frameOffsets)
	local result
	if params.poleTrafficLight == true then
		result = { 0, 0 } -- pedestrian, pole
	else
		result = { 0 } -- pedestrian
	end
	local idx = 1
	for i = #result + 1, count do
		result[i] = frameOffsets[i] + params.lightOffset[idx]
		idx = math.min(idx + 1, #params.lightOffset)
	end
	return result
end

local function pedestrianPoleNeeded(args, fti)
	local needTrafficLightPole = false
	local needPedestrianPole = false

	for i = fti.from, fti.to, fti.inc do
		if args.pedestrian[i] then
			if args.needsLight[i] then
				needPedestrianPole = true
			end
		elseif args.needsLight[i] then
			needTrafficLightPole = true
		end
	end

	if needTrafficLightPole and needPedestrianPole then
		return false
	end
	return needPedestrianPole
end

local function getTransformations(args, fti, pos, poleOffset, offsets, rotate, subtractOffset, rotateFirstModel)
	local result = { }

	for i = fti.from, fti.to, fti.inc do
		local p = pos.traffic
		if args.pedestrian[i] then
			p = pos.pedestrian
		end
		local o = offsets[#result + 1] + poleOffset
		local rot = 0
		if subtractOffset then
			o = -o
		end
		if rotate or (rotateFirstModel and #result == 0) then
			rot = math.pi
		end
		result[#result + 1] = transf.mul(p, transf.rotZTransl(rot, vec3.new(0, o, 0)))
	end
	return result
end

local function getPoleModels(args, models, fti, poleTrafficLight)
	local pedestrianPole = false
	local trafficLightPole = false
	for i = fti.from, fti.to, fti.inc do
		if args.needsLight[i] then
			if args.pedestrian[i] then
				pedestrianPole = true
			else
				trafficLightPole = true
			end
		end
	end
	if args.oppositePosition then
		if trafficLightPole and pedestrianPole then
			return { models.pedestrianPole, models.trafficLightPole }
		end
	end
	if trafficLightPole then
		return { nil, models.trafficLightPole }
	elseif pedestrianPole then
		return { models.pedestrianPole }
	else
		return { }
	end
end

local function getBeamModels(args, models, fti, poleTrafficLight)
	local moreLightModelsToCome = { }

	for i = fti.to, fti.from, -fti.inc do
		if not args.pedestrian[i] then
			if args.needsLight[i] then
				moreLightModelsToCome[i] = true
			else
				moreLightModelsToCome[i] = moreLightModelsToCome[i + fti.inc]
			end
		end
	end

	local result = { }
	local beamIdx = 1
	if poleTrafficLight  then
		beamIdx = 0
	end
	local resultIdx = 1
	for i = fti.from, fti.to, fti.inc do
		if not args.pedestrian[i] then
			if not moreLightModelsToCome[i] then
				break
			end
			if beamIdx > 0 then
				result[resultIdx] = models.beam[beamIdx]
			end
			beamIdx = math.min(beamIdx + 1, #models.beam)
		end
		resultIdx = resultIdx + 1
	end
	return result
end

local function getLightModels(args, models, fti)
	local result = { }

	local tlIdx = 1
	local resultIdx = 1
	for i = fti.from, fti.to, fti.inc do
		if args.needsLight[i] then
			if args.pedestrian[i] then
				result[resultIdx] = models.pedestrianLight
			else
				result[resultIdx] = models.trafficLight[tlIdx]
			end
		end
		if not args.pedestrian[i] then
			tlIdx = math.min(tlIdx + 1, #models.trafficLight)
		end
		resultIdx = resultIdx + 1
	end
	return result
end

local function add(mdls, transfs, mdl, transf)
	if mdl then
		mdls[#mdls + 1] = mdl
		transfs[#transfs + 1] = transf
	end
end

function trafficlightutil.standardLights(input)
	local models = input.models
	local params = input.params

	return function(args)
		local result = { }
		local n = #args.widths

		local split = splitLeftRight(args)
		local fromToR = split2FromTo(split, true )
		local fromToL = split2FromTo(split, false)

		local rightFrameOffsets = getFrameOffsets(args, params, split.right)
		local  leftFrameOffsets = getFrameOffsets(args, params, split.left )
		local rightLightOffsets = getLightOffsets(args, params, split.right, rightFrameOffsets)
		local  leftLightOffsets = getLightOffsets(args, params, split.left ,  leftFrameOffsets)

		local position = getPositions(args)
		local right = {}
		local left = {}
		right.lightTransformations = getTransformations(args, fromToR, position.right, params.offset, rightLightOffsets, false, true , false)
		 left.lightTransformations = getTransformations(args, fromToL, position.left , params.offset,  leftLightOffsets, false, false, true )
		right.frameTransformations = getTransformations(args, fromToR, position.right, params.offset, rightFrameOffsets, false, true , false)
		 left.frameTransformations = getTransformations(args, fromToL, position.left , params.offset,  leftFrameOffsets, true,  false, false)

		right.lightModels = getLightModels(args, models, fromToR)
		 left.lightModels = getLightModels(args, models, fromToL)
		right.poleModels  =  getPoleModels(args, models, fromToR, params.poleTrafficLight)
		 left.poleModels  =  getPoleModels(args, models, fromToL, params.poleTrafficLight)
		right.beamModels  =  getBeamModels(args, models, fromToR, params.poleTrafficLight)
		 left.beamModels  =  getBeamModels(args, models, fromToL, params.poleTrafficLight)

		local mdlIdx = 1
		local firstLight = true
		for i = 1, n do
			local j = i
			local t = right

			if i > split.right then
				j = n - i + 1
				t = left
			end

			local mdls = {}
			local transfs = {}
			add(mdls, transfs, t.lightModels[j], t.lightTransformations[j])
			add(mdls, transfs, t.poleModels[j] , t.frameTransformations[j])
			add(mdls, transfs, t.beamModels[j] , t.frameTransformations[j])

			if t.lightModels[j] then
				if firstLight then
					firstLight = false
				else
					mdlIdx = mdlIdx + 1
				end
			end

			if not result[mdlIdx] then
				result[mdlIdx] = { }
			end

			local r = result[mdlIdx]

			for k = 1, #mdls do
				r[#r + 1] = {
					id = mdls[k],
					transf = transfs[k]
				}
			end
		end

		return { models = result }
	end
end

return trafficlightutil

