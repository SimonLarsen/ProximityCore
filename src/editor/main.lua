require("LoveFrames")
require("Tserial")
require("util")
class = require("middleclass.middleclass")
local Level = require("Level")

-- Constants
local WIDTH = 900
local HEIGHT = 670

local LAYOUT_NAMES = { "Visuals", "Movement", "Bullets" }
local BULLET_TYPES = { "Balls", "Ray", "Bomb", "Radial" }

-- Data
local layouts = {
	Visuals = { panel = nil },
	Movement = { panel = nil },
	Bullets = { panel = nil, type = nil }
}

local bullet_forms = {
	Balls = { panel = nil, count = nil, offset = nil },
	Ray = { panel = nil, dir = nil },
	Bomb = { panel = nil, radius = nil },
	Radial = { panel = nil, startdir = nil, enddir = nil }
}

local BULLET_FIELDS = {
	Balls 	= { "count", "offset" },
	Ray		= { "dir" },
	Bomb	= { "radius" },
	Radial	= { "startdir", "enddir" }
}

local statustext

-- Objects
local placeholder, point
local state
local level, song
local time, scroll, start, playing
local seclen, bartime, beattime, ticktime

-- Visuals
local bars = {0,0,0}

local vera11

function love.load()
	love.window.setMode(WIDTH, 670)
	love.graphics.setBackgroundColor(232,232,232)
	love.graphics.setLineStyle("rough")
	vera11 = love.graphics.newFont(11)

	createFrames()

	placeholder = love.graphics.newImage("assets/placeholder.png")
	point = love.graphics.newImage("assets/point.png")

	filename = "fearless"
	time = 0
	scroll = 0
	start = 0
	playing = false

	loadLevel(filename)
end

function loadLevel(filename)
	local strdata = love.filesystem.read("levels/" .. filename) 
	level = Level()
	level:deserialize(strdata)

	song = love.audio.newSource("songs/" .. level:getSong(), "stream")

	love.window.setTitle("Proximity Core editor - " .. level:getName())

	seclen = level:getBPM() * 40 / 60
	bartime = (WIDTH-50) / seclen
	beattime = 1 / (level:getBPM() / 60)
	ticktime = beattime / 4
	state = LAYOUT_NAMES[1]
end

function saveLevel(filename)
	local strdata = level:serialize()
	love.filesystem.write("levels/" .. filename, strdata)
end

function createFrames()
	local topmenu = loveframes.Create("list")
	topmenu:SetDisplayType("horizontal")
	topmenu:SetPos(0,0)
	topmenu:SetSize(WIDTH, 20)

	-- Create menu
	local saveButton = loveframes.Create("button")
	saveButton:SetText("Save")
	saveButton.OnClick = function(object)
		saveLevel(filename)
	end

	local layoutChoice = loveframes.Create("multichoice")
	for i,v in ipairs(LAYOUT_NAMES) do
		layoutChoice:AddChoice(v)
	end
	layoutChoice:SetChoice(LAYOUT_NAMES[1])
	layoutChoice.OnChoiceSelected = function(object, choice)
		state = choice
		for i,v in pairs(layouts) do
			if v.panel then
				v.panel:SetVisible(i == choice)
			end
		end
	end

	topmenu:AddItem(saveButton)
	topmenu:AddItem(layoutChoice)

	-- Create bullets sidebar
	bp = loveframes.Create("panel")
	layouts.Bullets.panel = bp
	bp:SetPos(640, 20):SetSize(WIDTH-640, 480)
	bp:SetVisible(false)

	local bl = loveframes.Create("list", bp)
	bl:SetPos(5, 5)
	bl:SetSize(250, 230)

	local bt = loveframes.Create("multichoice", bp)
	bt:SetPos(5, 240)
	layouts.Bullets.type = bt
	bt.OnChoiceSelected = function(object, choice)
		for i,v in pairs(bullet_forms) do
			if v.panel then
				v.panel:SetVisible(i == choice)
			end
		end
	end

	for i,v in ipairs(BULLET_TYPES) do
		bt:AddChoice(v)

		local form = loveframes.Create("grid", bp)
		bullet_forms[v].panel = form
		form:SetPos(5, 270)
		form:SetColumns(2)
		form:SetRows(#BULLET_FIELDS[v])
		form:SetCellWidth(115)
		form:SetItemAutoSize(true)
		for j, w in ipairs(BULLET_FIELDS[v]) do
			form:AddItem(loveframes.Create("text"):SetText(w), j, 1)
			local input = loveframes.Create("textinput")
			form:AddItem(input, j, 2)
		end
		form:SetVisible(false)
	end

	-- Bottom bottom status bar
	local status = loveframes.Create("panel")
	status:SetPos(0, HEIGHT-20)
	status:SetSize(WIDTH, 20)
	statustext = loveframes.Create("text", status):SetPos(4,4)
end

function getTimelineTime(x)
	return (x - 50) / seclen + scroll
end

function getTimelineTick(x)
	return math.floor(getTimelineTime(x) / ticktime)
end

function love.update(dt)
	loveframes.update(dt)

	-- Timeline
	local mx, my = love.mouse.getPosition()
	if love.mouse.isDown("l") then
		if my >= 500 and my <= 515 and mx >= 50 then
			time = (mx - 50) / seclen + scroll
			song:seek(time)
		end
	end
	if love.mouse.isDown("r") then
		if my >= 515 and my < 595 and mx > 50 then
			local tick = getTimelineTick(mx)
			local type = math.floor((my-515)/27)+1
			level:deleteVisual(tick, type)
		end
	end

	time = math.max(0, time)
	if playing then
		time = song:tell()
	end

	if time > scroll + bartime*0.90 then
		scroll = time - bartime*0.90
	end
	if time < scroll + bartime*0.1 then
		scroll = time - bartime*0.1
	end
	scroll = math.max(0, scroll)

	statustext:SetText(timestr(time))

	-- Visuals
	local currenttick = math.floor(time / ticktime)
	for i=1,3 do
		bars[i] = math.max(0, bars[i] - 3 * dt)
	end
	for i,v in ipairs(level:getVisuals()) do
		if v.tick == currenttick then
			bars[v.type] = math.min(1, bars[v.type] + 32*dt)
		end
	end
end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)

	if button == "l" then
		if y >= 515 and y <= 596 and x > 50 then
			local tick = getTimelineTick(x)
			local type = math.floor((y-515)/27)+1
			level:addVisual(tick, type)
		end
	
	elseif button == "r" then

	elseif button == "wd" then
		time = time + beattime / 2

	elseif button == "wu" then
		time = time - beattime
	end
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function love.keypressed(k)
	loveframes.keypressed(k)
	if k == " " then
		if playing then
			playing = false
			song:pause()
		else
			start = time
			playing = true
			song:play()
			song:seek(time)
		end

	elseif k == "kp0" or k == "home" then
		if time == start then
			time = 0
		else
			time = start
		end
		scroll = time
		song:seek(time)
	end
end

function love.keyreleased(k)
	loveframes.keyreleased(k)
end

function love.textinput(text)
	loveframes.textinput(text)
end

function love.draw()
	drawTimeline()
	if state == "Visuals" then
		drawVisualsView()
	end

	loveframes.draw()
end

function drawTimeline()
	local scrollpos = scroll * seclen
	local timepos = 50 + (time-scroll) * seclen

	love.graphics.setColor(41,41,41)
	love.graphics.rectangle("fill", 0, 500, WIDTH, 150)

	love.graphics.setScissor(50, 500, WIDTH-50, 150)

	local offset = scrollpos % 40
	-- Draw bars
	love.graphics.setColor(61,61,61)
	for i=0, math.floor((WIDTH-50+seclen)/20) do
		love.graphics.rectangle("fill", 50+i*20-offset, 500, 10, 150)
	end

	-- Draw lines
	love.graphics.setColor(22,22,22)
	love.graphics.rectangle("fill", 50, 500, WIDTH-50, 15)

	love.graphics.setColor(180,180,180)
	for i=0,math.floor((WIDTH-50+seclen)/10) do
		if i % 4 == 0 then
			love.graphics.line(i*10+50.5-offset, 500, i*10+50.5-offset, 650)
		else
			love.graphics.line(i*10+50.5-offset, 500, i*10+50.5-offset, 515)
		end
	end
	love.graphics.setScissor()

	-- Draw track boxes
	love.graphics.setColor(0,0,0,80)
	love.graphics.rectangle("fill", 0, 515, WIDTH, 27)
	love.graphics.rectangle("fill", 0, 569, WIDTH, 27)
	love.graphics.rectangle("fill", 0, 623, WIDTH, 27)
	love.graphics.setColor(255,255,255)

	-- Draw current state
	if state == "Visuals" then
		drawTimelineVisuals()
	end

	-- Draw time marker
	love.graphics.setColor(225,37,37)
	love.graphics.line(timepos+0.5, 500, timepos+0.5, 650)
	love.graphics.setColor(255,255,255)
end

function drawTimelineVisuals()
	local scrollpos = scroll * seclen
	love.graphics.setFont(vera11)
	love.graphics.print("Ch. 1", 5, 523)
	love.graphics.print("Ch. 2", 5, 550)
	love.graphics.print("Ch. 3", 5, 577)

	love.graphics.setScissor(50, 515, WIDTH-50, 135)
	for i,v in ipairs(level:getVisuals()) do
		love.graphics.draw(point, 50+v.tick*ticktime*seclen-scrollpos, 515+(v.type-1)*27)
	end
	love.graphics.setScissor()
end

function drawVisualsView()
	love.graphics.setColor(116,205,124)
	love.graphics.rectangle("fill", 0, 20, 640, 480)

	love.graphics.setColor(225,225,225)
	local angleinc = math.pi*2 / 3
	for i=1,3 do
		love.graphics.arc("fill", 320, 280, bars[i]*200, (-i+1-0.25)*angleinc, (-i-0.25)*angleinc)
	end

	love.graphics.setColor(255,255,255)
end
