-- MovementController.lua (LocalScript)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("src"):WaitForChild("shared")

local InputConfig = require(Shared:WaitForChild("InputConfig"))
local AnimationManager = require(Shared:WaitForChild("AnimationManager"))
local StateManager = require(Shared:WaitForChild("StateManager"))
local DashHandler = require(Shared:WaitForChild("DashHandler"))

humanoid.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Freefall then
		StateManager.Set("isInAir", true)
	elseif newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
		StateManager.Set("isInAir", false)
	end
end)

-- Key state tracking
local keyStates = {
	move = Vector3.zero,
	sprinting = false,
}

-- Hotkey bindings (configurable)
local KEY_JUMP = InputConfig.JUMP_KEY
local KEY_SPRINT = InputConfig.SPRINT_KEY
local KEY_DASH = InputConfig.DASH_KEY

-- Update movement direction from input
local function updateMovementDirection()
	local direction = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Vector3.new(0, 0, -1) end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction += Vector3.new(0, 0, 1) end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction += Vector3.new(-1, 0, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Vector3.new(1, 0, 0) end
	keyStates.move = direction.Unit.Magnitude > 0 and direction.Unit or Vector3.zero
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == KEY_JUMP and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		AnimationManager:play("Jump")
	elseif input.KeyCode == KEY_SPRINT then
		keyStates.sprinting = true
		StateManager:setState("Sprinting")
		AnimationManager:play("Sprint")
	elseif input.KeyCode == KEY_DASH and not StateManager:isStunned() then
		DashHandler:dash(character, keyStates.move)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == KEY_SPRINT then
		keyStates.sprinting = false
		StateManager:setState("Walking")
		AnimationManager:play("Walk")
	end
end)

-- Animation updates every frame
RunService.RenderStepped:Connect(function()
	updateMovementDirection()

	if StateManager:isStunned() then return end

	if keyStates.sprinting and keyStates.move.Magnitude > 0 then
		AnimationManager:play("Sprint")
	elseif keyStates.move.Magnitude > 0 then
		AnimationManager:play("Walk")
	else
		AnimationManager:play("Idle")
	end
end)
