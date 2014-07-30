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
