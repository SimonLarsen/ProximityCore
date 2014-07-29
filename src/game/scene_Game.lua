local Scene = require("Scene")
local Animation = require("Animation")

local Game = class("Game", Scene)

function Game:start()
	print("started!")
end

function Game:update(dt)
	print("update!")
end

return Game
