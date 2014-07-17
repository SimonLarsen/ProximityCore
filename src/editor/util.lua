function timestr(time)
	local mins = math.floor(time / 60)
	local secs = math.floor(time % 60)
	local mils = math.floor(time % 1 * 100)
	return mins .. ":" .. string.format("%02d", secs) .. ":" .. string.format("%02d", mils)
end
