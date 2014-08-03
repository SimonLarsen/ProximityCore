local Vector2 = class("prox.Vector2")
local Mathf = require("prox.Mathf")

function Vector2:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Vector2:normalized()
	local len = math.sqrt(self.x^2 + self.y^2)
	return Vector2(x/len, y/len)
end

function Vector2:set(x,y)
	self.x, self.y = x, y
end

function Vector2.static:lerp(a, b, t)
	return Vector2(
		Mathf.lerp(a.x, b.x, t),
		Mathf.lerp(a.y, b.y, t)
	)
end

function Vector2.static:smoothstep(a, b, t)
	return Vector2(
		Mathf.smoothstep(a.x, b.x, t),
		Mathf.smoothstep(a.y, b.y, t)
	)
end

return Vector2
