class = require("middleclass.middleclass")
Gamestate = require("hump.gamestate")
Entities = require("entities")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(require("gamestates.game"))
end

function love.update(dt)
	
end

function love.draw()

end
