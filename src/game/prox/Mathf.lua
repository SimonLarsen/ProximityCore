local Mathf = {}

function Mathf.clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

function Mathf.lerp(a, b, t)
	t = Mathf.clamp(t, 0, 1)
	return (t-1)*a + t*b
end

function Mathf.smoothstep(a, b, t)
	local t = Mathf.clamp(t, 0, 1)
	return Mathf.lerp(a, b, t*t*(3-2*t))
end

function Mathf.sign(x)
	return x < 0 and -1 or 1
end

function Mathf.signz(x)
	return x < 0 and -1 or x > 0 and 1 or 0
end

function Mathf.round(x)
	return math.floor(x + 0.5)
end

function Mathf.seq(first, last, increment)
	local t = {}
	local inch = increment or 1
	for i=first,last,inch do
		table.insert(t, i)
	end
	return t
end

return Mathf
