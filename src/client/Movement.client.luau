--!strict
-- Side-scroller controls: A/D or arrows move on X, Space jumps,
-- W/S (or Up/Down) hop between the back / middle / front lanes.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local player = Players.LocalPlayer
local laneZ: { number } = Config.Lanes.Z
local laneIndex: number = Config.Lanes.Default

local humanoid: Humanoid? = nil
local laneAlign: AlignPosition? = nil

-- Replace the default 3D controls with our own.
local playerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule") :: ModuleScript) :: any
playerModule:GetControls():Disable()

local function applyLane()
	if laneAlign then
		laneAlign.Position = Vector3.new(0, 0, laneZ[laneIndex])
	end
end

local function changeLane(step: number)
	local newIndex = math.clamp(laneIndex + step, 1, #laneZ)
	if newIndex ~= laneIndex then
		laneIndex = newIndex
		applyLane()
	end
end

local function setupCharacter(character: Model)
	local newHumanoid = character:WaitForChild("Humanoid") :: Humanoid
	local root = character:WaitForChild("HumanoidRootPart") :: BasePart

	-- Only the Z axis is driven, so X/Y stay under normal physics.
	local attachment = Instance.new("Attachment")
	attachment.Name = "LaneAttachment"
	attachment.Parent = root

	local align = Instance.new("AlignPosition")
	align.Name = "LaneAlign"
	align.Mode = Enum.PositionAlignmentMode.OneAttachment
	align.Attachment0 = attachment
	align.ApplyAtCenterOfMass = true
	align.RigidityEnabled = false
	align.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	align.MaxAxesForce = Vector3.new(0, 0, 1e6)
	align.MaxVelocity = Config.Lanes.SwitchSpeed
	align.Responsiveness = 50
	align.Parent = root

	humanoid = newHumanoid
	laneAlign = align
	laneIndex = Config.Lanes.Default
	applyLane()

	newHumanoid.Died:Once(function()
		if humanoid == newHumanoid then
			humanoid = nil
			laneAlign = nil
		end
	end)
end

UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
	if processed then
		return
	end
	local key = input.KeyCode
	if key == Enum.KeyCode.W or key == Enum.KeyCode.Up then
		changeLane(-1) -- deeper
	elseif key == Enum.KeyCode.S or key == Enum.KeyCode.Down then
		changeLane(1) -- closer
	end
end)

RunService.RenderStepped:Connect(function()
	local current = humanoid
	if not current or UserInputService:GetFocusedTextBox() then
		return
	end
	local direction = 0
	if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
		direction += 1
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
		direction -= 1
	end
	-- Camera looks along +Z, so screen right is world -X.
	current:Move(Vector3.new(-direction, 0, 0), false)
	current.Jump = UserInputService:IsKeyDown(Enum.KeyCode.Space)
end)

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	task.spawn(setupCharacter, player.Character)
end
