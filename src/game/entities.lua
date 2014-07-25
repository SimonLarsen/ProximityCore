local Entities = class("Entities")

function Entities:initialize()
	self:clear()
end

function Entities:clear()
	self.entities = {}
end

function Entities:update(dt)
	for i, e in ipairs(self.entities) do
		for j, c in pairs(e:getComponents()) do
			if c.update then
				c:update(dt)
			end
		end
	end
end

function Entities:draw()
	for i, e in ipairs(self.entities) do
		if e.renderer then
			-- render
		end
	end
end

return Entities
