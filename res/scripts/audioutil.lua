local audioutil = { }

local function round(x)
	return math.floor(x + .5)
end

local function plot(fn, x0, x1, num)
	local result = { }

	for i = 0, num do
		local x = x0 + (x1 - x0) * i / num
		table.insert(result, { x, fn(x) })
	end

	return result
end

function audioutil.plotSqrtY(refSpeed, y0, y1)
	local x0 = y0 * y0 * refSpeed
	local x1 = y1 * y1 * refSpeed

	-- TODO ?

	local step = .1

	if x0 < .1 then
		step = .025
	elseif x0 < .2 then
		step = .05
	end

	local n = math.max(round((x1 - x0) / step), 1)

	return plot(function (x) return math.sqrt(x / refSpeed) end, x0, x1, n)
end


function audioutil.plotSqrt(x0, y0, x1, y1, num)
	local result = { }

	for i = 0, num do
		local f = i / num
		local x = x0 + (x1 - x0) * f * f
		local y = y0 + (y1 - y0) * f
		table.insert(result, { x, y })
	end

	return result
end

function audioutil.sampleCurve(nodes, x)
	local value = 0.0
	
	if 1 < #nodes then
		local n0
		local n1
		for i = 2, #nodes do
			n0 = nodes[i - 1]
			n1 = nodes[i]
			if x <= n1[1] then break end
		end
		value = math.mapClamp(x, n0[1], n1[1], n0[2], n1[2])
	else
		value = nodes[1][2]
	end
	
	return value
end

-- deprecated
function audioutil.makeRoadVehicle1(speeds, idle, idleSpeed, drive, driveSpeed, refDist)
	return {
		{
			clip = { name = idle, refDist = refDist },
			gainCurve = {
				nodes = {
					{ speeds[1], 1.0 },
					{ speeds[2], .0 },
				}
			},
			pitchCurve = { nodes = audioutil.plotSqrtY(idleSpeed, .8, 1.25) }
		}, {
			clip = { name = drive, refDist = refDist },
			gainCurve = {
				nodes = {
					{ speeds[1], .0 },
					{ speeds[2], 1.0 },
				}
			},
			pitchCurve = { nodes = audioutil.plotSqrtY(driveSpeed, .8, 1.5) }
		}
	}
end

-- deprecated
function audioutil.makeRoadVehicle2(speeds, idle, idleSpeed, idleGain0, drive, driveSpeed, refDist)
	return {
		{
			clip = { name = idle, refDist = refDist },
			gainCurve = {
				nodes = {
					{ .0, idleGain0 },
					{ speeds[1], 1.0 },
					{ speeds[2], 1.0 },
					{ speeds[3], .0 },
				}
			},
			pitchCurve = { nodes = audioutil.plotSqrtY(idleSpeed, .8, 1.25) }
		}, {
			clip = { name = drive, refDist = refDist },
			gainCurve = {
				nodes = {
					{ speeds[2], .0 },
					{ speeds[3], 1.0 },
				}
			},
			pitchCurve = { nodes = audioutil.plotSqrtY(driveSpeed, .8, 1.5) }
		}
	}
end

return audioutil
