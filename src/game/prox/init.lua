class = require("prox.middleclass.middleclass")
local Gamestate = require("prox.hump.gamestate")

local prox = {
	-- Overloadable callbacks
	load = function() end,
	exit = function() end,

	-- Expose modules
	Animation   = require("prox.Animation"),
	Animator    = require("prox.Animator"),
	Entity      = require("prox.Entity"),
	Gamestate   = require("prox.hump.gamestate"),
	Log         = require("prox.Log"),
	Mathf       = require("prox.Mathf"),
	Preferences = require("prox.Preferences"),
	Resources   = require("prox.Resources"),
	Scene       = require("prox.Scene"),
	Script      = require("prox.Script"),
	Transform   = require("prox.Transform"),
	Vector2     = require("prox.Vector2"),
}

function love.load()
	Gamestate.registerEvents()

	prox.load()
end

function love.update(dt)
	Gamestate.current():baseUpdate(dt)
end

function love.draw()
	Gamestate.current():baseDraw()
end

function love.exit()
	prox.exit()
end

return prox
