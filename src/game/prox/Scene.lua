local Entity = require("prox.Entity")

local Scene = class("Scene")

function Scene:initialize()
	self._entities = {}
end

function Scene:baseUpdate(dt)
	for i,e in ipairs(self:getEntities()) do
		for j,c in pairs(e:getComponents()) do
			if c.update then
				c:update(dt)
			end
		end
	end
end

function Scene:baseDraw()
	for i,e in ipairs(self:getEntities()) do
		local r = e:getComponent("renderer")
		if r then
			local t = e.transform
			r:draw(t.position.x, t.position.y, t.rotation, t.scale.x, t.scale.y)
		end
	end
end

function Scene:newEntity()
	local e = Entity()
	table.insert(self._entities, e)
	return e
end

function Scene:getEntities()
	return self._entities
end

-- Callback called when scene is entered
function Scene:start() end

-- Callback called on every frame
function Scene:update(dt) end

return Scene
