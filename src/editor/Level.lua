local Level = class("Level")

function Level:initialize(name, song, bpm)
	self._name = name
	self._song = song
	self._bpm = bpm
	self._data = {
		visuals = {}
	}
end

function Level:getName()
	return
self._name end

function Level:setName(name)
	self._name = name
end

function Level:getSong()
	return self._song
end

function Level:getBPM()
	return self._bpm
end

function Level:addVisual(time, type)
	local beatlen = 1 / (self._bpm / 60) / 4
	for i,v in ipairs(self._data.visuals) do
		if time >= v.time and time <= v.time+beatlen and v.type == type then
			return
		end
	end
	local beattime = 1 / (self._bpm / 60)
	time = math.floor(time / (beattime/4)) * (beattime/4)
	table.insert(self._data.visuals, {time=time, type=type})
end

function Level:deleteVisual(time, type)
	local beatlen = 1 / (self._bpm / 60) / 4
	for i,v in ipairs(self._data.visuals) do
		if time >= v.time and time <= v.time+beatlen and v.type == type then
			table.remove(self._data.visuals, i)
			return
		end
	end
end

function Level:getVisuals()
	return self._data.visuals
end

function Level:serialize()
	local data = {}
	data.name = self._name
	data.song = self._song
	data.bpm = self._bpm
	data.data = self._data
	return Tserial.pack(data)
end

function Level:deserialize(str)
	local data = Tserial.unpack(str)
	self._name = data.name
	self._song = data.song
	self._bpm = data.bpm
	self._data = data.data
end

return Level
