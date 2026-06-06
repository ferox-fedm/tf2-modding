local t = {}

function t.busStationOutline(origin)
	local x0 = 24
	local x1 = 6
	local x2 = 30
	return {
		{ -x0,  x0 },
		{ -x0, -x0 },
		{  x0, -x0 },
		{  x0,  x0 },
		{  x1,  x0 },
		{  x1,  x2 },
		{ -x1,  x2 },
		{ -x1,  x0 },
	}
end

function t.streetDepotOutline(origin)
	local x0 = 10
	local x1 = 20
	return {
		{ -x0,  x1 },
		{ -x0, -x1 },
		{  x0, -x1 },
		{  x0,  x1 },
	}
end

function t.railStationHeadOutline(origin)
	local x0 = 80
	local x1 = 15
	return {
		{  x1, -x0 },
		{  x1,  x0 },
		{ -x1,  x0 },
		{ -x1, -x0 },
	}
end

function t.railStationOutline(origin)
	local x0 = 80
	local x1 = 12
	local x2 = 25
	return {
		{ -x1, -x0 },
		{  x1, -x0 },
		{  x1,  x0 },
		{ -x1,  x0 },
		{ -x1,  x1 },
		{ -x2,  x1 },
		{ -x2, -x1 },
		{ -x1, -x1 },
	}
end

function t.railDepotOutline(origin)
	local x0 = 12
	local x1 = 35
	return {
		{ -x0,  x1 },
		{ -x0, -x1 },
		{  x0, -x1 },
		{  x0,  x1 },
	}
end

return t
