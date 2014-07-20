local WIDTH = 640
local HEIGHT = 480
local COLORS = {
	{235, 239, 244},
	{171, 188, 208},
	{51, 78, 109}
}
local DEATH_PROB = 0.99
local MIN_TRIANGLE_SIZE = 20
local MIN_RECTANGLE_SIZE = 40
local MAX_SIZE = 30

local shapes = {}

function love.load()
	love.window.setMode(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(94, 124, 157)

	rebuild()
end

function rebuild()
	shapes = {}
	createShape({type="rectangle", color=1, x=0, y=0, rot=0, width=WIDTH, height=HEIGHT}, 1, 12)
	print("Shapes:", #shapes)
end

function getColor(parent)
	if parent and love.math.random() < 0.6 then
		return parent.color
	else
		return love.math.random(1,#COLORS)
	end
end

function createTriangle(parent, xoffset, yoffset, rotoffset, size)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset - rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		rot = parent.rot+rotoffset,
		size = size,
		color = getColor(parent),
		scale = 1,
		type = "triangle"
	}
end

function createRectangle(parent, xoffset, yoffset, rotoffset, width, height)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset - rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		rot = parent.rot+rotoffset,
		width = width, height = height,
		color = getColor(parent),
		scale = 1,
		type = "rectangle"
	}
end

function createParallelogram(parent, xoffset, yoffset, rotoffset, width, height, length)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset - rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		rot = parent.rot+rotoffset,
		width = width, height = height,
		color = getColor(parent),
		scale = 1,
		type = "parallelogram"
	}
end

function createShape(parent, depth, maxdepth)
	if parent.type == "triangle" then
		if love.math.random() < DEATH_PROB and parent.size < MAX_SIZE then
			return
		end

		local action = love.math.random(1,2)
		if depth > maxdepth or parent.size <= 2*MIN_TRIANGLE_SIZE then -- Stop
			table.insert(shapes, parent)
		elseif action == 1 then -- Slice in 2 tris and one rect
			local x = love.math.random(MIN_TRIANGLE_SIZE, parent.size-MIN_TRIANGLE_SIZE)
			local y = parent.size - x
			local t1 = createTriangle(parent, 0, y, 0, x)
			local t2 = createTriangle(parent, x, 0, 0, y)
			local rect = createRectangle(parent, 0, 0, 0, x, y)
			createShape(t1, depth+1, maxdepth)
			createShape(t2, depth+1, maxdepth)
			createShape(rect, depth+1, maxdepth)
		elseif action == 2 then -- Slice in two equal sized tris
			local tsize = math.sqrt(2 * ((parent.size/2)^2))
			local t1 = createTriangle(parent, parent.size/2, parent.size/2, 0.75*math.pi, tsize)
			local t2 = createTriangle(parent, parent.size/2, parent.size/2, 1.25*math.pi, tsize)
			createShape(t1, depth+1, maxdepth)
			createShape(t2, depth+1, maxdepth)
		end
	elseif parent.type == "rectangle" then
		if love.math.random() < DEATH_PROB and parent.width < MAX_SIZE and parent.height < MAX_SIZE then
			return
		end

		local action = love.math.random(1,2)
		if depth > maxdepth or math.max(parent.width,parent.height) <= 2*MIN_RECTANGLE_SIZE then -- Stop
			table.insert(shapes, parent)
			return
		end
		if action == 1 then
			if parent.height > parent.width then -- Slice horizontal
				local y = parent.height/2
				local top = createRectangle(parent, 0, y, 0, parent.width, parent.height-y)
				local bottom = createRectangle(parent, 0, 0, 0, parent.width, y)
				createShape(top, depth+1, maxdepth)
				createShape(bottom, depth+1, maxdepth)
			else -- Slice vertical
				local x = parent.width/2
				local left = createRectangle(parent, 0, 0, 0, x, parent.height)
				local right = createRectangle(parent, x, 0, 0, parent.width-x, parent.height)
				createShape(left, depth+1, maxdepth)
				createShape(right, depth+1, maxdepth)
			end

		elseif action == 2 then -- Slice triangles + parallelogram
			if parent.height > parent.width then
			end
			local t1 = createTriangle(parent, 0, parent.height, 1.5*math.pi, parent.height)
			local t2 = createTriangle(parent, parent.width, 0, 0.5*math.pi, parent.height)
			createShape(t1, depth+1, maxdepth)
			createShape(t2, depth+1, maxdepth)
			if parent.width > 2*parent.height then
				local diff = parent.width - parent.height
				local rect = createRectangle(parent, diff/2, 0, 0, diff/2, parent.height)
				createShape(rect, depth+1, maxdepth)
			elseif parent.width > parent.height then
				local diff = parent.width - parent.height
				local trihyp = math.sqrt(2 * (diff/2)^2)
				local rectwidth = math.sqrt(2 * parent.height^2) - trihyp
				local rect = createRectangle(parent, diff, 0, 0.25*math.pi, rectwidth, trihyp)
				createShape(rect, depth+1, maxdepth)
			end
		end
	end
end

function love.update(dt)

end

function love.draw()
	local mx, my = love.mouse.getPosition()

	for i,v in ipairs(shapes) do
		love.graphics.push()
		love.graphics.translate(v.x, v.y)
		if v.type ~= "parallelogram" then
			love.graphics.rotate(v.rot)
		end

		local time = love.timer.getTime()
		local sqdist = (v.x-WIDTH/2)^2 + (v.y-HEIGHT/2)^2
		local scale = math.cos(sqdist/50000 + love.timer.getTime()*2)^2
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

function love.keypressed(k)
	if k == "r" then
		rebuild()
	end
end
