local Transform = require("transform")

local Entity = class("Entity")

function Entity:initialize(transform, name)
	self.name = name or ""
	self._components = {}
	self.transform = transform or Transform()
end

function Entity:getComponents()
	return self._components
end

function Entity:addComponent(name, c)
	self._components[name] = c
end

function Entity:getComponent(name)
	return self._components[name]
end

return Entity
