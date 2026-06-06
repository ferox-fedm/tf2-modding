local vec2 = require "vec2"

local polygonutil = { }

function polygonutil.transform(mat, polygon)
	local result = { }
	
	for i = 1, #polygon do
		result[i] = { 
			mat[1] * polygon[i][1] + mat[5] * polygon[i][2] + mat[13],
			mat[2] * polygon[i][1] + mat[6] * polygon[i][2] + mat[14]
		}
	end
	
	return result
end

function polygonutil.makeQuad(bottomLeft, topRight)
	return {
		{ bottomLeft[1], bottomLeft[2] },
		{ topRight[1], bottomLeft[2] },
		{ topRight[1], topRight[2] },
		{ bottomLeft[1], topRight[2] },	
	}
end

function polygonutil.contains(polygon, pos)
	for i = 1, #polygon do 
		if (polygon[i][1] == pos[1] and polygon[i][2] == pos[2]) then return true end
	end
	
	local oddNodes = false

	for i = 1, #polygon do
		local v0 = polygon[i]
		local v1 = polygon[1 + (#polygon + i - 2) % #polygon]			
	
		if ((v0[2] < pos[2] and v1[2] >= pos[2]) or (v1[2] < pos[2] and v0[2] >= pos[2])) then
			if (v0[1] + (pos[2] - v0[2]) / (v1[2] - v0[2]) * (v1[1] - v0[1]) < pos[1]) then
				oddNodes = not oddNodes
			end
		end
	end
	
	return oddNodes
end

function polygonutil.offset(polygon, offset)
	local result = { }
	
	for i = 1, #polygon do	
		local v0 = polygon[i]
		local v1 = polygon[1 + i % #polygon]
		local v2 = polygon[1 + (i + 1) % #polygon]
	
		local dir0 = vec2.rotate90(vec2.normalize(vec2.new(v1[1] - v0[1], v1[2] - v0[2])))
		local dir1 = vec2.rotate90(vec2.normalize(vec2.new(v2[1] - v1[1], v2[2] - v1[2])))
	
		local diff = vec2.mul(offset / math.cos(vec2.angle(dir0, dir1) * .5), vec2.normalize(vec2.add(dir0, dir1)))
	
		result[i] = { v1[1] - diff.x, v1[2] - diff.y }
	end
	
	return result
end

return polygonutil
