local Vector2 = class("Vector2")

function Vector2:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Vector2:normalized()
	local len = math.sqrt(self.x^2 + self.y^2)
	return Vector2(x/len, y/len)
end

return Vector2
