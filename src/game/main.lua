class = require("middleclass.middleclass")
Gamestate = require("hump.gamestate")

local Game = require("scene_Game")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(Game())
end

function love.update(dt)
	Gamestate.current():update(dt)
end

function love.draw()
	Gamestate.current():draw()
end
