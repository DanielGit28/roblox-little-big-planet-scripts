--!strict
-- Photo mode: press the photo key (or the on-screen button) to capture the
-- screen and offer to save it to the player's Roblox Captures gallery.

local CaptureService = game:GetService("CaptureService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "PhotoUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "PhotoButton"
button.AnchorPoint = Vector2.new(1, 1)
button.Position = UDim2.new(1, -16, 1, -16)
button.Size = UDim2.fromOffset(56, 56)
button.Text = "📷"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(255, 244, 230)
button.AutoButtonColor = true
button.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = button

local busy = false

local function takePhoto()
	if busy then
		return
	end
	busy = true

	-- Hide our own UI so it stays out of the picture.
	gui.Enabled = false
	local ok, err = pcall(function()
		CaptureService:CaptureScreenshot(function(contentId)
			gui.Enabled = true
			CaptureService:PromptSaveCapturesToGallery({ contentId }, function() end)
		end)
	end)
	if not ok then
		gui.Enabled = true
		warn("Photo failed:", err)
	end

	task.delay(Config.Photo.CooldownSeconds, function()
		gui.Enabled = true
		busy = false
	end)
end

button.Activated:Connect(takePhoto)
UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
	if not processed and input.KeyCode == Config.Photo.Key then
		takePhoto()
	end
end)
