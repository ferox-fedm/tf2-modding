local transf = require "transf"
local vec2 = require "vec2"
local vec3 = require "vec3"

local vehicleutil = { }

local function distToTime(dist)
	return 1000 * dist
end

local function calcNumSteps(radius)
	-- TODO ?
	return 16
end


function vehicleutil.makeCouplingRodAnim(wheelCenter, wheelPos0)
	local radius = vec2.distance(wheelPos0, wheelCenter)
	local wheelAngle0 = math.atan2(wheelPos0.y - wheelCenter.y, wheelCenter.x - wheelPos0.x)

	local duration = distToTime(2.0 * math.pi * wheelCenter.y)
	local num = calcNumSteps(radius)

	local keyframes = { }

	for i = 0, num do
		local f = i / num

		--local angle = wheelAngle0 + dist / wheelCenter.y
		local angle = wheelAngle0 + 2.0 * math.pi * f

		local wheelPos = vec2.add(wheelCenter, vec2.mul(radius, vec2.new(-math.cos(angle), math.sin(angle))))

		table.insert(keyframes, {
			time = duration * f,
			transf = transf.transl(vec3.new(wheelPos.x - wheelPos0.x, .0, wheelPos.y - wheelPos0.y))
		})
	end

	return {
		type = "KEYFRAME_MATRIX",
		params = {
			keyframes = keyframes
		}
	}
end

function vehicleutil.makePistonAnim(wheelCenter, wheelPos0, pistonPos0)
	local length = vec2.distance(wheelPos0, pistonPos0)
	local radius = vec2.distance(wheelPos0, wheelCenter)
	local rodAngle0 = math.atan((wheelPos0.y - pistonPos0.y) / (pistonPos0.x - wheelPos0.x))
	local wheelAngle0 = math.atan2(wheelPos0.y - wheelCenter.y, wheelCenter.x - wheelPos0.x)

	local duration = distToTime(2.0 * math.pi * wheelCenter.y)
	local num = calcNumSteps(radius)

	local keyframes = { }

	for i = 0, num do
		local f = i / num

		--local angle = wheelAngle0 + dist / wheelCenter.y
		local angle = wheelAngle0 + 2.0 * math.pi * f

		local wheelPos = vec2.add(wheelCenter, vec2.mul(radius, vec2.new(-math.cos(angle), math.sin(angle))))

		local dy = wheelPos.y - pistonPos0.y
		local dx = math.sqrt(length * length - dy * dy)
		local pistonPos = vec2.new(wheelPos.x + dx, pistonPos0.y)

		table.insert(keyframes, {
			time = duration * f,
			transf = transf.transl(vec3.new(pistonPos.x - pistonPos0.x, .0, .0))
		})
	end

	return {
		type = "KEYFRAME_MATRIX",
		params = {
			keyframes = keyframes
		}
	}
end

function vehicleutil.makeConnectingRodAnim(wheelCenter, wheelPos0, pistonPos0)
	local length = vec2.distance(wheelPos0, pistonPos0)
	local radius = vec2.distance(wheelPos0, wheelCenter)
	local rodAngle0 = math.atan((wheelPos0.y - pistonPos0.y) / (pistonPos0.x - wheelPos0.x))
	local wheelAngle0 = math.atan2(wheelPos0.y - wheelCenter.y, wheelCenter.x - wheelPos0.x)

	local duration = distToTime(2.0 * math.pi * wheelCenter.y)
	local num = calcNumSteps(radius)

	local keyframes = { }

	for i = 0, num do
		local f = i / num

		--local angle = wheelAngle0 + dist / wheelCenter.y
		local angle = wheelAngle0 + 2.0 * math.pi * f

		local wheelPos = vec2.add(wheelCenter, vec2.mul(radius, vec2.new(-math.cos(angle), math.sin(angle))))

		local dy = wheelPos.y - pistonPos0.y
		local dx = math.sqrt(length * length - dy * dy)
		local pistonPos = vec2.new(wheelPos.x + dx, pistonPos0.y)

		table.insert(keyframes, {
			time = duration * f,
			--transf = transf.rotYCntTransl(math.atan(dy / dx) - rodAngle0, vec3.new(pistonPos0.x, .0, pistonPos0.y),
			--		vec3.new(pistonPos.x - pistonPos0.x, .0, .0))
			transf = transf.rotYCntTransl(math.atan(dy / dx) - rodAngle0, vec3.new(pistonPos0.x - wheelPos0.x, .0, pistonPos0.y - wheelPos0.y),
					vec3.new(pistonPos.x - pistonPos0.x, .0, .0))
		})
	end

	return {
		type = "KEYFRAME_MATRIX",
		params = {
			keyframes = keyframes
		}
	}
end

return vehicleutil
