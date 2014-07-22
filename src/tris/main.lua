local Trigen = require("trigen")
local shaders = require("shaders")

local WIDTH = 640
local HEIGHT = 480
local COLORS = {
--	{235, 239, 244},
	{146,167,188},
	{47,73,103}
}

local shapes = {}
local canvas, shader
local overlay

function love.load()
	love.window.setMode(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(10,10,10)
	love.graphics.setDefaultFilter("nearest","nearest")

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	shader = love.graphics.newShader(shaders.shader.convolution3x3.pixelcode)
	local xoff = 1 / WIDTH
	local yoff = 1 / HEIGHT
	shader:send("offset", unpack(shaders.generateOffsets3x3(WIDTH, HEIGHT)))
	shader:send("kernel", unpack(shaders.matrix.sharpen3x3))
	overlay = love.graphics.newImage("overlay.png")

	rebuild()
end

function rebuild()
	shapes = Trigen.generate(WIDTH, HEIGHT)
end

function love.update(dt)

end

function drawShapes(shapes)
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
	love.graphics.setShader(shader)
	love.graphics.draw(canvas)
	love.graphics.setShader()
	--love.graphics.draw(overlay, 0, 0)
end

function love.keypressed(k)
	if k == "r" then
		rebuild()
	end
end
