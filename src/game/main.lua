class = require("middleclass.middleclass")
require("mymath")

local Gamestate = require("hump.gamestate")
local Resources = require("Resources")
local Game = require("scene_Game")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(Game())
end

function love.update(dt)
	Gamestate.current():baseUpdate(dt)
end

function love.draw()
	Gamestate.current():baseDraw()
end
