local t = {}

function t.makeCircleZone(pos, radius, num)
	num = num or 24

	local result = { }
	for i = 1, num do
		local s = 2.0 * math.pi * (i - 1) / num
		result[i] = { pos[1] + radius * math.cos(s), pos[2] + radius * math.sin(s) }
	end
	return result
end

return t
