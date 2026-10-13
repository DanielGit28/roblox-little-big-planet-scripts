--!strict
-- Adjustable game values. Placeholder numbers: tune them in playtests.

local Config = {
	Players = {
		Min = 1,
		Max = 8,
		Lives = 3,
	},

	-- Side-view play: camera sits at -Z looking along +Z (screen right = -X).
	Lanes = {
		Z = { 8, 0, -8 }, -- 1 = back (far from camera), 2 = middle, 3 = front (near)
		Default = 2,
		SwitchSpeed = 30, -- studs/second when hopping between lanes
	},

	Camera = {
		Distance = 14, -- studs in front of the middle lane (initial zoom)
		MinDistance = 8, -- closest zoom
		MaxDistance = 80, -- farthest zoom
		ZoomStep = 5, -- studs per mouse-wheel notch
		HeightOffset = 6, -- studs above the character
		FieldOfView = 55,
		Smoothness = 8, -- higher = snappier follow
		-- Occlusion: if a solid sits between character and camera (bus side, box
		-- wall...) the camera moves in front of it, inside the space.
		OcclusionMargin = 0.5, -- studs kept between camera and the blocking face
		OcclusionMinDistance = 2, -- never closer than this to the character
		OcclusionMinSize = 4, -- ignore parts smaller than this (debris, bits)
		OcclusionTransparency = 0.5, -- parts at least this transparent don't block
		IgnoreTag = "CameraIgnore", -- CollectionService tag: never blocks the camera
	},

	-- Close-up when the character is inside a hollow space (bunker, bus, box...).
	Indoor = {
		Distance = 5, -- studs from the character's own lane (ignores the wheel)
		HeightOffset = 1, -- studs above the character while enclosed
		RayRange = 14, -- studs: how far to look for walls/ceiling
		-- Enclosed = ceiling + (left & right walls) or (front & back walls).
		EnterSeconds = 0.25, -- enclosed this long before zooming in
		ExitSeconds = 0.6, -- open this long before zooming back out
		CheckInterval = 0.1, -- seconds between raycast checks
	},

	Photo = {
		Key = Enum.KeyCode.P,
		CooldownSeconds = 2,
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

	Points = {
		PerTick = 1, -- points awarded each tick
		TickSeconds = 1, -- seconds between ticks
	},

	Round = {
		-- No time limit: rounds end by reaching the goal or last player standing.
		IntermissionSeconds = 5,
	},
}

return Config
