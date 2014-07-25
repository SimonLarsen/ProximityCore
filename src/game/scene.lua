local Entity = require("entity")

local Scene = class("Scene")

function Scene:initialize()
	self._entities = {}
end

function Scene:update(dt)
	for i,e in ipairs(self._entities) do
		for j,c in pairs(e:getComponents()) do
			if c.update then
				c:update(dt)
			end
		end
	end
end

function Scene:draw()
	for i,e in ipairs(self._entities) do
		local r = e:getComponent("renderer")
		if r then
			local t = e.transform
			r:draw(t.x, t.y, t.r, t.sx, t.sy)
		end
	end
end

function Scene:newEntity()
	local e = Entity()
	table.insert(self._entities, e)
	return e
end

return Scene
