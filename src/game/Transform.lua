local Vector2 = require("Vector2")

local Transform = class("Transform")

function Transform:initialize(pos,layer,r,sx,sy)
	self.pos = pos or Vector2()
	self.layer = layer or 0
	self.r = r or 0
	self.sx = sx or 1
	self.sy = sy or 1
end

return Transform
