local transf = require "transf"
local vec3 = require "vec3"

local colliderutil = { }

function colliderutil.createBox(center, halfExtents)
	local result = { }
	
	result.type = "BOX"
	
	if center ~= nil then result.transf = transf.transl(vec3.new(center[1], center[2], center[3])) end
	
	if halfExtents ~= nil then
		result.params = { }
		result.params.halfExtents = halfExtents
	end
	
	return result
end

function colliderutil.createCylinder(direction, center, halfExtents)
	local result = { }
	
	result.type = "CYLINDER"
	
	result.transf = { .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, .0, 1.0 }
	
	local idx = { 1, 2, 3 }
	local invIdx = { 1, 2, 3 }
	if direction ~= nil then
		if direction == "X" then 
			idx = { 3, 1, 2 }
			invIdx = { 2, 3, 1 }
		end
		if direction == "Y" then
			idx = { 1, 3, 2 }
			invIdx = { 1, 3, 2 }
		end
	end
	
	for i = 1, 3 do result.transf[(idx[i] - 1) * 4 + i] = 1.0 end
	
	if center ~= nil then
		result.transf[13] = center[1]
		result.transf[14] = center[2]
		result.transf[15] = center[3]
	end
	
	if halfExtents ~= nil then
		result.params = { }
		result.params.halfExtents = { halfExtents[invIdx[1]], halfExtents[invIdx[2]], halfExtents[invIdx[3]] }
	end
	
	return result
end

function colliderutil.createPointCloud(points)
	local result = { }
	
	result.type = "POINT_CLOUD"
	result.params = { }
	result.params.points = points
	
	return result
end

function colliderutil.extrudePoints(points, offset1, offset2)
	local result = {}
	
	for i = 1, #points do
		table.insert(result, { points[i][1], points[i][2], points[i][3] + offset1 })
		table.insert(result, { points[i][1], points[i][2], points[i][3] + offset2 })
	end
	
	return result
end

return colliderutil
