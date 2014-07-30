class = require("middleclass.middleclass")

local Gamestate = require("hump.gamestate")
local Resources = require("Resources")
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
