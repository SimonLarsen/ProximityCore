local Game = class("Game", prox.Scene)

function Game:enter()
	self.time = 0

	self.player = self:newEntity()
	self.player:addComponent("renderer", prox.Animator(prox.Resources.static:getAnimator("player.lua")))
	self.player.transform.position:set(400, 300)
end

function Game:update(dt)
	self.time = self.time + dt
end

return Game
