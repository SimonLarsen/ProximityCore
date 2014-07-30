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

Resources.static.sounds_path = "data/sounds/"
Resources.static.sounds = {}

function Resources.static:getSound(path)
	path = self.sounds_path .. path

	if self.sounds[path] == nil then
		self.sounds[path] = love.audio.newSource(path, "static")
		Log.static:print("Loaded sound: " .. path)
	end

	return self.sounds[path]
end

Resources.static.animators_path = "data/animators/"
Resources.static.animators = {}

function Resources.static:getAnimator(path)
	path = self.animators_path .. path

	if self.animators[path] == nil then
		local f = loadfile(path)
		self.animators[path] = f()
		Log.static:print("Loaded animator: " .. path)
	end

	return self.animators[path]
end

return Resources
