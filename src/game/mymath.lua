function math.clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

function math.lerp(a, b, t)
	t = math.clamp(t, 0, 1)
	return (t-1)*a + t*b
end

function math.smoothstep(a, b, t)
	local t = math.clamp(t, 0, 1)
	return math.lerp(a, b, t*t*(3-2*t))
end

function math.sign(x)
	return x < 0 and -1 or 1
end

function math.signz(x)
	return x < 0 and -1 or x > 0 and 1 or 0
end

function math.round(x)
	return math.floor(x + 0.5)
end

function math.seq(first, last, increment)
	local t = {}
	local inch = increment or 1
	for i=first,last,inch do
		table.insert(t, i)
	end
	return t
end
