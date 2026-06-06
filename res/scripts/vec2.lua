local vec2 = { }

function vec2.new(x, y)
	return { x = x, y = y }
end

function vec2.add(a, b)
	return { x = a.x + b.x, y = a.y + b.y }
end

function vec2.sub(a, b)
	return { x = a.x - b.x, y = a.y - b.y }
end

function vec2.componentwiseMul(v1, v2)
	return { x = v1.x * v2.x, y = v1.x * v2.y }
end

function vec2.componentwiseDiv(v1, v2)
	return { x = v1.x / v2.x, y = v1.y / v2.y }
end

function vec2.div(v, f)
	return { x = v.x / f, y = v.y / f }
end

function vec2.mul(f, v)
	return { x = f * v.x, y = f * v.y }
end

function vec2.length(v)
	return math.sqrt(v.x * v.x + v.y * v.y)
end

function vec2.distance(a, b)
	return vec2.length(vec2.sub(a, b))
end

function vec2.dot(a, b)
	return a.x * b.x + a.y * b.y
end

function vec2.normalize(v)
	return vec2.mul(1.0 / vec2.length(v), v)
end

function vec2.lerp(a, b, s)
	return vec2.add(a, vec2.mul(s, vec2.sub(b, a)))
end

function vec2.rotate90(v) 
	return vec2.new(-v.y, v.x)
end

function vec2.angle(a, b)
	local arg = vec2.dot(a, b) / (vec2.length(a) * vec2.length(b))
	if arg < -1.0 then arg = -1.0 elseif arg > 1.0 then arg = 1.0 end
	return math.acos(arg)
end

function vec2.herp(p0, p1, t0, t1, s) 
	local s2 = s*s
	local s3 = s2*s
	local h2 = -2.0*s3 + 3.0*s2
	local h3 = s3 - 2.0*s2 + s
	local h4 = s3 - s2

	return vec2.add(
		p0, 
		vec2.add(
			vec2.mul(h2, vec2.sub(p1, p0)),
			vec2.add(
				vec2.mul(h3, t0),
				vec2.mul(h4, t1)
			)
		)
	)
end

function vec2.herpPrime(p0, p1, t0, t1, s) 
	local s2 = s*s
	local h2 = -6.0*s2 + 6.0*s
	local h3 = 3.0*s2 - 4.0*s + 1.0
	local h4 = 3.0*s2 - 2.0*s

	return vec2.add(
		vec2.mul(h2, vec2.sub(p1, p0)),
		vec2.add(
			vec2.mul(h3, t0),
			vec2.mul(h4, t1)
		)
	)
end

function vec2.fromAngle(x)
	return vec2.new(math.cos(x), math.sin(x))
end

return vec2
