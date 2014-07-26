local DEATH_PROB = 0.99
local MIN_TRIANGLE_SIZE = 20
local MIN_RECTANGLE_SIZE = 40
local MAX_SIZE = 30
local NCOLORS = 2

local shapes

local function getColor(parent)
	if parent and love.math.random() < 0.6 then
		return parent.color
	else
		return love.math.random(1,NCOLORS)
	end
end

local function createTriangle(parent, xoffset, yoffset, rotoffset, size)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset - rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		rot = parent.rot+rotoffset,
		size = size,
		color = getColor(parent),
		scale = 0,
		type = "triangle"
	}
end

local function createRectangle(parent, xoffset, yoffset, rotoffset, width, height)
	local rcos = math.cos(parent.rot)
	local rsin = math.sin(parent.rot)
	return {
		x = parent.x + rcos*xoffset - rsin*yoffset,
		y = parent.y + rsin*xoffset + rcos*yoffset,
		rot = parent.rot+rotoffset,
		width = width, height = height,
		color = getColor(parent),
		scale = 0,
		type = "rectangle"
	}
end

local function createShape(parent, depth, maxdepth)
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
			-- Commented out because it makes it look much cooler
			--[[
			if parent.height > parent.width then
				-- parent = createRectangle(parent, 0, parent.height, 1.5*math.pi, parent.height, parent.width)
			end
			--]]
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

local function generate(width, height)
	shapes = {}
	createShape({type="rectangle", color=1, x=0, y=0, rot=0, width=width, height=height}, 1, 12)
	return shapes
end

return {
	generate = generate
}
