return {
	default = "idle",

	properties = {
		["blush"] = { value = false, isTrigger = true }
	},

	states = {
		["idle"] = {
			image = "player_idle.png",
			fw = 32, fh = 64, delay = 0.25
		},
		["flying"] = {
			image = "player_flying.png",
			fw = 39, fh = 66, delay = 0.25
		},
		["blush"] = {
			image = "player_blush.png",
			fw = 32, fh = 64, delay = 0.25
		}
	},

	transitions = {
		{
			from = "idle", to = "blush",
			property = "blush", value = true
		},
		{
			from = "blush", to = "idle",
			property = "finished", value = true
		}
	}
}
