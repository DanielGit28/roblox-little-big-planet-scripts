--!strict
-- Adjustable game values. Placeholder numbers: tune them in playtests.

local Config = {
	Players = {
		Min = 1,
		Max = 8,
		Lives = 3,
	},

	Bombs = {
		BlastRadius = 8, -- studs, fixed for every bomb
		InitialInterval = 3, -- seconds between drops at round start
		MinInterval = 0.5, -- floor: drops never get faster than this
		IntervalDecay = 0.97, -- multiplier applied after each drop
		SpawnHeight = 100, -- studs above the map, in the invisible strip
	},

	Debris = {
		MaxActive = 150, -- cap on live physics debris
		CleanupY = -200, -- debris below this height is removed
	},

	Round = {
		-- No time limit: rounds end by reaching the goal or last player standing.
		IntermissionSeconds = 5,
	},
}

return Config
