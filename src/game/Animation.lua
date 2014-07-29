local Animation = {}
Animation.__index = Animation

function Animation.create(image, fw, fh, delay, ox, oy)
	self = setmetatable({}, Animation)

	self._image = image

	local imgw = image:getWidth()
	local imgh = image:getHeight()

	local xframes = math.floor(imgw / fw)
	local yframes = math.floor(imgh / fh)

	self._quads = {}
	for iy = 0, yframes-1 do
		for ix = 0, xframes-1 do
			local q = love.graphics.newQuad(ix*fw, iy*fh, fw, fh, imgw, imgh)
			table.insert(self._quads, q)
		end
	end

	self._frames = xframes * yframes
	self._delay = delay
	self._frame = 1
	self._time = 0
	self._speed = 1
	self._ox = ox or (fw/2)
	self._oy = oy or (fh/2)

	return self
end

function Animation:update(dt)
	self._time = self._time + dt * self._speed
	if self._time >= self._delay then
		self._time = 0
		self._frame = self._frame + 1
		if self._frame > self._frames then
			self._frame = 1
		end
	end
end

function Animation:draw(x, y, r, sx, sy)
	love.graphics.draw(self._image, self._quads[self._frame], x, y, r, sx, sy, self._ox, self._oy)
end

function Animation:setSpeed(speed)
	self._speed = speed
end

function Animation:setOrigin(ox, oy)
	self._ox = ox
	self._oy = oy
end

return setmetatable(Animation, { __call = function(self, ...) return Animation.create(...) end })
