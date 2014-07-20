local Level = class("Level")

function Level:initialize(name, song, bpm)
	self._name = name
	self._song = song
	self._bpm = bpm
	self._data = {
		visuals = {
			-- {tick=[number], type=[1,2,3]}
		}
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

function Level:addVisual(tick, type)
	for i,v in ipairs(self._data.visuals) do
		if tick == v.tick and type == v.type then
			return
		end
	end
	table.insert(self._data.visuals, {tick=tick, type=type})
end

function Level:deleteVisual(tick, type)
	for i,v in ipairs(self._data.visuals) do
		if tick == v.tick and type == v.type then
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
