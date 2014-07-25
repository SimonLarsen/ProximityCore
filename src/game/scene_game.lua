local Scene = require("scene")
local Animation = require("animation")

local Game = class("Game", Scene)

function Game:enter()
	Scene.initialize(self)
end

return Game
