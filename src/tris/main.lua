local WIDTH = 640
local HEIGHT = 480
local COLORS = {{235, 239, 244}, {171, 188, 208}, {51, 78, 109}}
local DEATH_PROB = 0.95
local MIN_TRIANGLE_SIZE = 20
local MIN_RECTANGLE_SIZE = 40
local MAX_SIZE = 30

local shapes

function love.load()
	love.window.setMode(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(94, 124, 157)

	rebuild()
end

function rebuild()
	shapes = {}
	createShape({type="triangle", color=COLORS[1],  x=WIDTH/2, y=HEIGHT/2, rot=math.pi, size=WIDTH/2}, 1, 10)
	createShape({type="triangle", color=COLORS[1],  x=WIDTH/2, y=HEIGHT/2, rot=0, size=WIDTH/2}, 1, 10)
	createShape({type="rectangle", color=COLORS[1], x=WIDTH/2, y=0, rot=0, width=WIDTH/2, height=HEIGHT/2}, 1, 10)
	createShape({type="rectangle", color=COLORS[1], x=0, y=HEIGHT/2, rot=0, width=WIDTH/2, height=HEIGHT/2}, 1, 10)
end

function getColor(parent)
	if love.math.random() < 0.6 then
		return parent.color
	else
		return COLORS[love.math.random(1,#COLORS)]
	end
end

function createTriangle(parent, xoffset, yoffset, rotoffset, size)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset + rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		color = getColor(parent),
		size = size,
		rot = parent.rot+rotoffset,
		type = "triangle"
	}
end

function createRectangle(parent, xoffset, yoffset, rotoffset, width, height)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset + rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		color = getColor(parent),
		width = width, height = height,
		rot = parent.rot+rotoffset,
		type = "rectangle"
	}
end

function createShape(parent, depth, maxdepth)
	if parent.type == "triangle" then
		if love.math.random() < DEATH_PROB and parent.size < MAX_SIZE then
			return
		end

		if depth > maxdepth or parent.size <= 2*MIN_TRIANGLE_SIZE then -- Stop
			table.insert(shapes, parent)
		else -- Slice
			local x = love.math.random(MIN_TRIANGLE_SIZE, parent.size-MIN_TRIANGLE_SIZE)
			local y = parent.size - x
			local t1 = createTriangle(parent, 0, y, 0, x)
			local t2 = createTriangle(parent, x, 0, 0, y)
			local rect = createRectangle(parent, 0, 0, 0, x, y)
			createShape(t1, depth+1, maxdepth)
			createShape(t2, depth+1, maxdepth)
			createShape(rect, depth+1, maxdepth)
		end
	elseif parent.type == "rectangle" then
		if love.math.random() < DEATH_PROB and parent.width < MAX_SIZE and parent.height < MAX_SIZE then
			return
		end

		local action = love.math.random(1,3)
		if depth > maxdepth -- Stop
		or (action == 1 and parent.height <= 2*MIN_RECTANGLE_SIZE)
		or (action == 2 and parent.width <= 2*MIN_RECTANGLE_SIZE) then
			table.insert(shapes, parent)
			return
		end
		if action == 1 then -- Slice horizontal
			local y = love.math.random(MIN_RECTANGLE_SIZE, parent.height-MIN_RECTANGLE_SIZE)
			local top = createRectangle(parent, 0, y, 0, parent.width, parent.height-y)
			local bottom = createRectangle(parent, 0, 0, 0, parent.width, y)
			createShape(top, depth+1, maxdepth)
			createShape(bottom, depth+1, maxdepth)
		elseif action == 2 then -- Slice vertical
			local x = love.math.random(MIN_RECTANGLE_SIZE, parent.width-MIN_RECTANGLE_SIZE)
			local left = createRectangle(parent, 0, 0, 0, x, parent.height)
			local right = createRectangle(parent, x, 0, 0, parent.width-x, parent.height)
			createShape(left, depth+1, maxdepth)
			createShape(right, depth+1, maxdepth)

		elseif action == 3 then -- Slice triangles
			local tsize = math.min(parent.width, parent.height)
			local t1 = createTriangle(parent, 0, 0, 0, tsize)
			local t2 = createTriangle(parent, parent.width, parent.height, math.pi, tsize)
			-- TODO: Make parallelogram
			createShape(t1, depth+1, maxdepth)
			createShape(t2, depth+1, maxdepth)
		end
	
	elseif parent.type == "parallelogram" then

	end
end

function love.update(dt)
	
end

function love.draw()
	for i,v in ipairs(shapes) do
		love.graphics.push()
		love.graphics.translate(v.x, v.y)
		love.graphics.rotate(v.rot)
		love.graphics.translate(-v.x, -v.y)

		love.graphics.setColor(v.color)
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
