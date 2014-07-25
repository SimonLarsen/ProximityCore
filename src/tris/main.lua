local Trigen = require("trigen")
local shaders = require("shaders")

local WIDTH = 640
local HEIGHT = 480

local COLORS = {
	{255,255,255},
	{128,128,128}
}

local shapes = {}
local canvas
local trishader
local overlay

function love.load()
	love.window.setMode(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(10,10,10)
	love.graphics.setDefaultFilter("nearest","nearest")

	overlay = love.graphics.newImage("overlay.png")
	bg = love.graphics.newImage("winter.png")

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

	trishader = love.graphics.newShader(shaders.shader.test.pixelcode)
	trishader:send("screen", {WIDTH,HEIGHT})
	trishader:send("bg", bg)
	trishader:send("offset", unpack(shaders.generateOffsets3x3(WIDTH, HEIGHT)))
	trishader:send("kernel", unpack(shaders.matrix.sharpen3x3))

	rebuild()
end

function rebuild()
	shapes = Trigen.generate(WIDTH, HEIGHT)
end

function love.update(dt)

end

local function drawShapes(shapes)
	for i,v in ipairs(shapes) do
		love.graphics.push()
		love.graphics.translate(v.x, v.y)
		love.graphics.rotate(v.rot)

		local time = love.timer.getTime()
		local sqdist = (v.x-WIDTH/2)^2 + (v.y-HEIGHT/2)^2
		local scale = math.cos(sqdist/50000 + love.timer.getTime()*2)^4
		love.graphics.scale(scale, scale)

		love.graphics.translate(-v.x, -v.y)

		love.graphics.setColor(COLORS[v.color])
		if v.type == "triangle" then
			love.graphics.polygon("fill", v.x, v.y, v.x, v.y+v.size, v.x+v.size, v.y)
		elseif v.type == "rectangle" then
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
		end
		love.graphics.pop()
	end
end

function love.draw()
	canvas:clear()
	love.graphics.setCanvas(canvas)

	drawShapes(shapes)

	love.graphics.setColor(255,255,255)

	love.graphics.setCanvas()
	love.graphics.setShader(trishader)
	love.graphics.draw(canvas)
	love.graphics.setShader()
	love.graphics.draw(overlay, 0, 0)
end

function love.keypressed(k)
	if k == "r" then
		rebuild()
	end
end
