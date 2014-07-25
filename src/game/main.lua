class = require("middleclass.middleclass")
Gamestate = require("hump.gamestate")
Entities = require("entities")

local Entity = require("entity")
local e

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(require("scene_game"))
end

function love.update(dt)
	Gamestate.current():update(dt)
end

function love.draw()
	Gamestate.current():draw()
end
