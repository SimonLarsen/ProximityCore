local Renderer = require("Renderer")
local Animation = require("Animation")
local Resources = require("Resources")

local Animator = class("Animator", Renderer)

function Animator:initialize(animator)
	self._states = animator.states
	self._transitions = animator.transitions

	self._animations = {}
	for i,v in pairs(self._states) do
		self._animations[i] = Animation(Resources.static:getImage(v.image), v.fw, v.fh, v.delay)
	end

	self._properties = {}
	for i,v in pairs(animator.properties) do
		self._properties[i] = {
			value = v.value,
			isTrigger = v.isTrigger
		}
	end
	self._properties["_finished"] = { value = false, isTrigger = true }

	self._state = animator.default
	self._animations[self._state]:reset()
end

function Animator:update(dt)
	self._animations[self._state]:update(dt)
	if self._animations[self._state]:isFinished() then
		self:setProperty("_finished", true)
	end

	for i,v in pairs(self._transitions) do
		if v.from == self._state then
			if self._properties[v.property].value == v.value then
				self._state = v.to
				self._animations[self._state]:reset()
				break
			end
		end
	end

	for i,v in pairs(self._properties) do
		if v.isTrigger then
			v.value = false
		end
	end
end

function Animator:draw(...)
	self._animations[self._state]:draw(...)
end

function Animator:setProperty(name, value)
	self._properties[name].value = value
end

return Animator
