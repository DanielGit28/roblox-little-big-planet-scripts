--!strict
-- Awards points over time. Stored as a "Points" attribute so clients can read it.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local function setup(player: Player)
	player:SetAttribute("Points", 0)
end

Players.PlayerAdded:Connect(setup)
for _, player in Players:GetPlayers() do
	setup(player)
end

task.spawn(function()
	while true do
		task.wait(Config.Points.TickSeconds)
		for _, player in Players:GetPlayers() do
			local current = player:GetAttribute("Points")
			if typeof(current) == "number" then
				player:SetAttribute("Points", current + Config.Points.PerTick)
			end
		end
	end
end)

print("[Rojo test] Points system loaded")
