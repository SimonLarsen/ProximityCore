local Entities = class("Entities")

function Entities:initialize()
	self:clear()
end

function Entities:clear()
	self.entities = {}
end

function Entities:update(dt)
	for i,v in ipairs(self.entities) do
		if v.behavior then
			v.behavior:update(dt)
		end
	end
end

function Entities:draw()
	for i,v in ipairs(self.entities) do
		if v.renderer then
			v.renderer:draw()
		end
	end
end

return Entities
