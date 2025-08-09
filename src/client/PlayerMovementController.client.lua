-- PlayerMovementController.lua
-- Handles player input, movement states, and animation triggers

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local InputConfig = require(game.ReplicatedStorage.Shared.InputConfig)
local StateManager = require(game.ReplicatedStorage.Shared.StateManager)

-- Handle character respawn
local function refreshCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(refreshCharacter)

local movementDirection = Vector3.zero
local isSprinting = false
local isJumping = false

-- Update direction vector and state
local function updateMovementDirection()
	local direction = Vector3.zero

	if UserInputService:IsKeyDown(InputConfig.Keys.Forward) then
		direction += Vector3.new(0, 0, -1)
	end
	if UserInputService:IsKeyDown(InputConfig.Keys.Backward) then
		direction += Vector3.new(0, 0, 1)
	end
	if UserInputService:IsKeyDown(InputConfig.Keys.Left) then
		direction += Vector3.new(-1, 0, 0)
	end
	if UserInputService:IsKeyDown(InputConfig.Keys.Right) then
		direction += Vector3.new(1, 0, 0)
	end

	if direction.Magnitude > 0 then
		movementDirection = direction.Unit
		local state = isSprinting and "Sprinting" or "Running"
		StateManager:Set(player, "Movement", state)
	else
		movementDirection = Vector3.zero
		StateManager:Set(player, "Movement", "Idle")
	end
end

-- Input begin handler
UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed then return end

	if input.KeyCode == InputConfig.Keys.Sprint then
		isSprinting = true
	elseif input.KeyCode == InputConfig.Keys.Jump then
		isJumping = true
		StateManager:Set(player, "Movement", "Jumping")
	end
end)

-- Input end handler
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == InputConfig.Keys.Sprint then
		isSprinting = false
	elseif input.KeyCode == InputConfig.Keys.Jump then
		isJumping = false
	end
end)

-- Frame-based checks
RunService.RenderStepped:Connect(function()
	updateMovementDirection()

	if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		StateManager:Set(player, "Movement", "Freefall")
	end
end)
