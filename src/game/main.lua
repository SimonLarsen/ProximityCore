prox = require("prox")

local Game = require("scene_Game")

function prox.load()
	prox.Gamestate.switch(Game())
end

function prox.exit()
	
end
