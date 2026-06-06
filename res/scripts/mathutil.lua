function math.round(x)
	return math.floor(x + .5)
end

function math.clamp(f, a, b)
	if (f < a) then return a end
	if (f > b) then return b end
	return f
end

function math.lerp(a, b, s)
	return a + (b - a) * s
end

function math.invLerp(x, a, b)
	return (x - a) / (b - a)
end

function math.map(x, a, b, c, d)
	return math.lerp(c, d, math.invLerp(x, a, b))
end

function math.mapClamp(x, a, b, c, d)
	local cc, dd
	if c < d then
		cc = c
		dd = d
	else
		cc = d
		dd = c
	end
	return math.clamp(math.map(x, a, b, c, d), cc, dd)
end

function math.randf(x, y)
	return math.map(math.random(), 0, 1, x, y)
end

function math.herp(p0, p1, t0, t1, s) 
	local s2 = s*s
	local s3 = s2*s
	local h2 = -2.0*s3 + 3.0*s2
	local h3 = s3 - 2.0*s2 + s
	local h4 = s3 - s2

	return p0 + h2 * (p1 - p0) + h3 * t0 + h4 * t1
end

function math.herpPrime(p0, p1, t0, t1, s) 
	local s2 = s*s
	local h2 = -6.0*s2 + 6.0*s
	local h3 = 3.0*s2 - 4.0*s + 1.0
	local h4 = 3.0*s2 - 2.0*s

	return h2 * (p1 - p0) + h3 * t0 + h4 * t1
end