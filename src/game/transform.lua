local Transform = class("Transform")

function Transform:initialize(x,y,z,r,sx,sy)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.r = r or 0
	self.sx = sx or 1
	self.sy = sy or 1
end

return Transform
