--!strict
-- Fixed front-facing 2D-style camera: sits at -Z looking along +Z, follows the
-- character on X/Y, never rotates. Mouse wheel zooms between Min/MaxDistance.
-- When the character is enclosed (bunker, bus, box) the camera closes in.

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera :: Camera

local baseZ: number = Config.Lanes.Z[Config.Lanes.Default]
local focus: Vector3 = Vector3.new(0, 0, 0)
local initialized = false

local targetDistance: number = Config.Camera.Distance
local cameraZ: number = baseZ - targetDistance
local heightOffset: number = Config.Camera.HeightOffset
local rootZ: number = baseZ

local UP = Vector3.new(0, 1, 0)
local LEFT = Vector3.new(-1, 0, 0)
local RIGHT = Vector3.new(1, 0, 0)
local TOWARD_CAMERA = Vector3.new(0, 0, -1)
local AWAY_FROM_CAMERA = Vector3.new(0, 0, 1)

local enclosed = false
local pendingSince: number? = nil -- when the raw state first differed from `enclosed`
local lastCheck = 0

UserInputService.InputChanged:Connect(function(input: InputObject, processed: boolean)
	if processed or input.UserInputType ~= Enum.UserInputType.MouseWheel then
		return
	end
	-- Wheel up (Position.Z > 0) zooms in.
	targetDistance = math.clamp(
		targetDistance - input.Position.Z * Config.Camera.ZoomStep,
		Config.Camera.MinDistance,
		Config.Camera.MaxDistance
	)
end)

-- First solid face along a ray that counts as a wall: big, opaque, untagged.
local function castBlocking(origin: Vector3, direction: Vector3, length: number): RaycastResult?
	local excluded: { Instance } = {}
	for _, other in Players:GetPlayers() do
		if other.Character then
			table.insert(excluded, other.Character)
		end
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.RespectCanCollide = false
	params.FilterDescendantsInstances = excluded

	for _ = 1, 6 do
		local result = workspace:Raycast(origin, direction * length, params)
		if not result then
			return nil
		end
		local part = result.Instance
		local size = part.Size
		local blocks = part.Transparency < Config.Camera.OcclusionTransparency
			and math.max(size.X, size.Y, size.Z) >= Config.Camera.OcclusionMinSize
			and not CollectionService:HasTag(part, Config.Camera.IgnoreTag)
		if blocks then
			return result
		end
		table.insert(excluded, part)
		params.FilterDescendantsInstances = excluded
	end
	return nil
end

-- Enclosed = ceiling overhead AND walls on both sides (left+right) or both
-- depths (front+back). A single wall or a lone roof does not count.
local function probeEnclosed(origin: Vector3): boolean
	local range = Config.Indoor.RayRange
	if not castBlocking(origin, UP, range) then
		return false
	end
	local sides = castBlocking(origin, LEFT, range) ~= nil and castBlocking(origin, RIGHT, range) ~= nil
	if sides then
		return true
	end
	return castBlocking(origin, TOWARD_CAMERA, range) ~= nil
		and castBlocking(origin, AWAY_FROM_CAMERA, range) ~= nil
end

local function updateEnclosed(origin: Vector3)
	local now = os.clock()
	if now - lastCheck < Config.Indoor.CheckInterval then
		return
	end
	lastCheck = now

	local raw = probeEnclosed(origin)
	if raw == enclosed then
		pendingSince = nil
		return
	end
	local since = pendingSince or now
	pendingSince = since
	local needed = if raw then Config.Indoor.EnterSeconds else Config.Indoor.ExitSeconds
	if now - since >= needed then
		enclosed = raw
		pendingSince = nil
	end
end

-- Z the camera must not go behind: the nearest wall face between the
-- character and the camera, or nil if the view is clear.
local OCCLUSION_OFFSETS: { number } = { -1.5, 0, 1.5 }

local function findOcclusionZ(origin: Vector3, length: number): number?
	if length <= 0 then
		return nil
	end
	local nearest: number? = nil
	for _, offset in OCCLUSION_OFFSETS do
		local result = castBlocking(origin + Vector3.new(offset, 0, 0), TOWARD_CAMERA, length)
		if result and (nearest == nil or result.Position.Z > nearest) then
			nearest = result.Position.Z
		end
	end
	return nearest
end

RunService:BindToRenderStep("SideCamera", Enum.RenderPriority.Camera.Value + 1, function(dt: number)
	-- Re-assert every frame: the default camera script resets this on respawn.
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = Config.Camera.FieldOfView

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		local target = root.Position
		if initialized then
			local alpha = 1 - math.exp(-Config.Camera.Smoothness * dt)
			focus = focus:Lerp(target, alpha)
		else
			focus = target
			initialized = true
		end
		rootZ = target.Z
		updateEnclosed(target)
	end

	-- Indoors: a separate close-up camera tied to the character's own lane.
	-- The wheel setting is kept and applies again once outdoors.
	local wantedDistance = if enclosed then Config.Indoor.Distance else targetDistance
	local wantedAnchor = if enclosed then rootZ else baseZ
	local wantedHeight = if enclosed then Config.Indoor.HeightOffset else Config.Camera.HeightOffset
	local wantedZ = wantedAnchor - wantedDistance

	-- Only when enclosed: slide in front of the wall, inside the space.
	local occludedZ: number? = nil
	if enclosed and root and root:IsA("BasePart") then
		local hitZ = findOcclusionZ(root.Position, rootZ - wantedZ)
		if hitZ then
			local limit = math.min(hitZ + Config.Camera.OcclusionMargin, rootZ - Config.Camera.OcclusionMinDistance)
			-- Only matters if the camera would end up behind the face.
			if wantedZ < limit then
				occludedZ = limit
			end
		end
	end

	local finalZ = occludedZ or wantedZ
	-- React fast when approaching the character (wall appearing), ease when leaving.
	local rate = if finalZ > cameraZ then 18 else 6
	cameraZ += (finalZ - cameraZ) * (1 - math.exp(-rate * dt))
	heightOffset += (wantedHeight - heightOffset) * (1 - math.exp(-6 * dt))

	-- Turn 180° around Y so the camera looks along +Z (screen right = -X).
	local position = Vector3.new(focus.X, focus.Y + heightOffset, cameraZ)
	camera.CFrame = CFrame.new(position) * CFrame.Angles(0, math.pi, 0)
end)
