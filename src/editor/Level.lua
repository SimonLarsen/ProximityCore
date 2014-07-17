local Level = class("Level")

function Level:initialize(name, song, bpm)
	self._name = name
	self._song = song
	self._bpm = bpm
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

return Level
