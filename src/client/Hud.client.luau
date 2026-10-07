--!strict
-- Fills the HUD_Maqueta points panel with live players, ranked by "Points".

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local panel = playerGui:WaitForChild("HUD_Maqueta"):WaitForChild("PanelPuntos")

type Row = {
	frame: Frame,
	nameLabel: TextLabel,
	scoreLabel: TextLabel,
}

-- Rows are Fila1..FilaN; the left-aligned label is the name, the right one the score.
local rows: { Row } = {}
for index = 1, 20 do
	local frame = panel:FindFirstChild("Fila" .. index)
	if not frame or not frame:IsA("Frame") then
		break
	end
	local nameLabel, scoreLabel
	for _, child in frame:GetChildren() do
		if child:IsA("TextLabel") then
			if child.TextXAlignment == Enum.TextXAlignment.Right then
				scoreLabel = child
			else
				nameLabel = child
			end
		end
	end
	if nameLabel and scoreLabel then
		table.insert(rows, { frame = frame, nameLabel = nameLabel, scoreLabel = scoreLabel })
	end
end

local function pointsOf(player: Player): number
	local points = player:GetAttribute("Points")
	return if typeof(points) == "number" then points else 0
end

local function render()
	local ranked = Players:GetPlayers()
	table.sort(ranked, function(a, b)
		local pa, pb = pointsOf(a), pointsOf(b)
		if pa ~= pb then
			return pa > pb
		end
		return a.Name < b.Name
	end)

	for index, row in rows do
		local player = ranked[index]
		row.frame.Visible = player ~= nil
		if player then
			row.nameLabel.Text = index .. ". " .. player.DisplayName
			row.scoreLabel.Text = tostring(pointsOf(player))
		end
	end
end

local function watch(player: Player)
	player:GetAttributeChangedSignal("Points"):Connect(render)
end

Players.PlayerAdded:Connect(function(player)
	watch(player)
	render()
end)
Players.PlayerRemoving:Connect(function()
	-- The leaving player is still listed during this event; render next frame.
	task.defer(render)
end)

for _, player in Players:GetPlayers() do
	watch(player)
end
render()

print("[Rojo test] HUD loaded")
