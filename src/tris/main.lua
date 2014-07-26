local Trigen = require("trigen")
local shaders = require("shaders")
local Animation = require("animation")

local WIDTH = 640
local HEIGHT = 480
local BPM = 130
local BEATTIME = BPM / 60

local COLORS = {
	{255,255,255},
	{128,128,128}
}

local pulse
local px, py
local dir, moving
local shapes = {}
local canvas
local trishader
local overlay, wireframe

local x, y
local anim_flying, anim_idle

function love.load()
	love.window.setMode(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(10,10,10)
	love.graphics.setDefaultFilter("nearest","nearest")

	overlay = love.graphics.newImage("overlay.png")
	bg = love.graphics.newImage("winter.png")

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

	trishader = love.graphics.newShader(shaders.shader.trishader.pixelcode)
	trishader:send("screen", {WIDTH,HEIGHT})
	trishader:send("bg", bg)
	trishader:send("offset", unpack(shaders.generateOffsets3x3(WIDTH, HEIGHT)))
	trishader:send("kernel", unpack(shaders.matrix.sharpen3x3))

	pulse = 1
	rebuild()

	x, y = WIDTH/2, HEIGHT/2
	dir = 1
	moving = false

	wireframe = love.graphics.newImage("wireframes.png")

	local sprite = love.graphics.newImage("flying.png")
	anim_flying = Animation(sprite, 39, 66, 0.1)

	sprite = love.graphics.newImage("idle.png")
	anim_idle = Animation(sprite, 32, 64, 0.25)
	anim_idle:setSpeed(BEATTIME)
end

function rebuild()
	shapes = Trigen.generate(WIDTH, HEIGHT)
end

local function updateShapes(shapes, dt)
	for i,v in ipairs(shapes) do
		v.scale = math.max(0, v.scale - dt*BEATTIME)

		--[[
		local radius = 250
		local sqdist = math.sqrt((px-v.x)^2 + (py-v.y)^2)
		if sqdist < radius then
			local scale = (1 - sqdist / radius + pulse) % 1
			if scale > 0.90 then
				v.scale = 1
			end
		end
		--]]
		---[[
		local radius = 50000
		local sqdist = (x-v.x)^2 + (y-v.y)^2
		if sqdist < radius then
			v.scale = math.min(1, 1 - (sqdist / radius) + (1-pulse)/5)
		end
		--]]
	end
end

function love.update(dt)
	local oldpulse = pulse
	pulse = (pulse + dt * BEATTIME) % 1
	if pulse < oldpulse then
		px, py = x, y
	end
	updateShapes(shapes, dt)

	anim_flying:update(dt)
	anim_idle:update(dt)

	local diller = 200
	moving = false
	if love.keyboard.isDown("up") then
		y = y - diller*dt
		moving = true
	end
	if love.keyboard.isDown("down") then
		y = y + diller*dt
		moving = true
	end
	if love.keyboard.isDown("left") then
		x = x - diller*dt
		dir = -1
		moving = true
	end
	if love.keyboard.isDown("right") then
		x = x + diller*dt
		dir = 1
		moving = true
	end
end

local function drawShapes(shapes)
	for i,v in ipairs(shapes) do
		love.graphics.push()

		love.graphics.translate(v.x, v.y)
		love.graphics.rotate(v.rot)
		love.graphics.scale(v.scale, v.scale)
		love.graphics.translate(-v.x, -v.y)

		love.graphics.setColor(COLORS[v.color])
		if v.type == "triangle" then
			love.graphics.polygon("fill", v.x, v.y, v.x, v.y+v.size, v.x+v.size, v.y)
		elseif v.type == "rectangle" then
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
		end
		love.graphics.pop()
	end
	love.graphics.setColor(255,255,255)
end

function love.draw()
	canvas:clear()
	love.graphics.setCanvas(canvas)

	drawShapes(shapes)

	love.graphics.setCanvas()
	love.graphics.draw(wireframe, 0, 0)
	love.graphics.setShader(trishader)
	local bgc = 185 + (1-pulse)*70
	love.graphics.setColor(bgc, bgc, bgc)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,255,255)
	love.graphics.setShader()

	if moving then
		anim_flying:draw(x, y, 0, dir, 1)
	else
		anim_idle:draw(x, y, 0, dir, 1)
	end
end

function love.keypressed(k)
	if k == "r" then
		rebuild()
	end
end
