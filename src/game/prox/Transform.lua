local Vector2 = require("prox.Vector2")

local Transform = class("Transform")

function Transform:initialize(position, layer, rotation, scale)
	self.position = position or Vector2(0, 0)
	self.layer = layer or 0
	self.rotation = r or 0
	self.scale = scale or Vector2(1, 1)
end

return Transform
