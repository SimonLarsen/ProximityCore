local Log = require("Log")

local Resources = class("Resources")

Resources.static.images_path = "data/images/"
Resources.static.images = {}

function Resources.static:getImage(path)
	path = self.images_path .. path

	if self.images[path] == nil then
		self.images[path] = love.graphics.newImage(path)
		Log.static:print("Loaded image: " .. path)
	end

	return self.images[path]
end

Resources.static.sounds_path = "data/sounds"
Resources.static.sounds = {}

function Resources.static:getSound(path)
	path = self.sounds_path .. path

	if self.sounds[path] == nil then
		self.sounds[path] = love.audio.newSource(path, "static")
		Log.static:print("Loaded sound: " .. path)
	end

	return self.sounds[path]
end

return Resources
