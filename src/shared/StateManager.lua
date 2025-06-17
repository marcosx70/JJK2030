-- StateManager.lua
-- Shared module that manages per-player state layering, history, and replication

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Event objects for local and remote state replication
local StateChanged = Instance.new("BindableEvent")
local StateChangedRemote = Instance.new("RemoteEvent")
StateChangedRemote.Name = "StateChangedRemote"
StateChangedRemote.Parent = ReplicatedStorage

-- Configuration
local LAYERS = { "Movement", "Action", "Combat" }

-- Internal state tracking
local PlayerStates = {} -- [player] = { [layer] = state }
local StateHistory = {} -- [player] = { [layer] = { state1, state2, ... } }

-- Utility to create default state for a player
local function initializePlayer(player)
	PlayerStates[player] = {}
	StateHistory[player] = {}
	for _, layer in ipairs(LAYERS) do
		PlayerStates[player][layer] = "Idle"
		StateHistory[player][layer] = { "Idle" }
	end
end

local function cleanupPlayer(player)
	PlayerStates[player] = nil
	StateHistory[player] = nil
end

-- Main API
local StateManager = {}

function StateManager:Set(player, layer, newState)
	assert(PlayerStates[player], "Player state not initialized")
	assert(table.find(LAYERS, layer), "Invalid layer")
	
	local currentState = PlayerStates[player][layer]
	if currentState == newState then return end
	
	PlayerStates[player][layer] = newState
	table.insert(StateHistory[player][layer], newState)
	
	-- Fire local and remote events
	StateChanged:Fire(player, layer, newState)
	StateChangedRemote:FireClient(player, layer, newState)
end

function StateManager:Get(player, layer)
	assert(PlayerStates[player], "Player state not initialized")
	return PlayerStates[player][layer]
end

function StateManager:IsIn(player, layer, statesTable)
	assert(PlayerStates[player], "Player state not initialized")
	return table.find(statesTable, PlayerStates[player][layer]) ~= nil
end

function StateManager:Revert(player, layer)
	assert(PlayerStates[player], "Player state not initialized")
	local history = StateHistory[player][layer]
	if #history > 1 then
		table.remove(history) -- Remove current state
		local previous = history[#history]
		self:Set(player, layer, previous)
	end
end

function StateManager:GetAll(player)
	return PlayerStates[player]
end

function StateManager:GetHistory(player, layer)
	return StateHistory[player][layer]
end

-- Bindable event listener (local only)
function StateManager:GetChangedSignal()
	return StateChanged.Event
end

-- Player join/leave handlers
Players.PlayerAdded:Connect(initializePlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)

-- Initialize any players already in-game
for _, player in ipairs(Players:GetPlayers()) do
	initializePlayer(player)
end

return StateManager
