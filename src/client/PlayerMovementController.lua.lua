-- StateManager.lua (Revised)

local StateManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function refreshCharacter()
	local newCharacter = player.Character or player.CharacterAdded:Wait()
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

-- Connect it:
player.CharacterAdded:Connect(function()
	refreshCharacter()
end)

-- Call once at start:
refreshCharacter()

local StateChanged = Instance.new("BindableEvent")
StateManager.StateChanged = StateChanged.Event

local StateChangedRemote = Instance.new("RemoteEvent")
StateChangedRemote.Name = "StateChangedRemote"
StateChangedRemote.Parent = ReplicatedStorage

local PlayerStates = {}
local StateHistory = {}

local LAYERS = {
	"Movement",
	"Action",
	"Combat"
}

local DEFAULT_STATE = "Idle"
local ALLOWED_STATES = {
	Movement = {
		Idle = true,
		Walking = true,
		Sprinting = true,
		Jumping = true,
		Falling = true,
		InAir = true,
		AirDash = true,
		AerialCombat = true,
		Stunned = true,
	},
	Action = {
		None = true,
		Punching = true,
		Kicking = true,
		Blocking = true,
	},
	Combat = {
		Passive = true,
		Aggressive = true,
		Defensive = true,
	}
}

local function initPlayerState(player)
	PlayerStates[player] = {}
	StateHistory[player] = {}
	for _, layer in ipairs(LAYERS) do
		PlayerStates[player][layer] = DEFAULT_STATE
		StateHistory[player][layer] = { DEFAULT_STATE }
	end
end

Players.PlayerAdded:Connect(initPlayerState)
Players.PlayerRemoving:Connect(function(player)
	PlayerStates[player] = nil
	StateHistory[player] = nil
end)

function StateManager:Set(player, layer, newState)
	assert(PlayerStates[player], "Player state not initialized")
	assert(table.find(LAYERS, layer), "Invalid layer: " .. tostring(layer))
	assert(ALLOWED_STATES[layer] and ALLOWED_STATES[layer][newState], "Invalid state for layer: " .. tostring(newState))

	if PlayerStates[player][layer] ~= newState then
		PlayerStates[player][layer] = newState
		table.insert(StateHistory[player][layer], newState)
		StateChanged:Fire(player, layer, newState)
		StateChangedRemote:FireClient(player, layer, newState)
	end
end

function StateManager:Get(player, layer)
	return PlayerStates[player] and PlayerStates[player][layer] or DEFAULT_STATE
end

function StateManager:GetAll(player)
	return table.clone(PlayerStates[player])
end

function StateManager:GetHistory(player, layer)
	return table.clone(StateHistory[player][layer])
end

function StateManager:Is(player, layer, states)
	local current = self:Get(player, layer)
	if type(states) == "string" then
		return current == states
	elseif type(states) == "table" then
		for _, s in ipairs(states) do
			if current == s then
				return true
			end
		end
	end
	return false
end

function StateManager:Revert(player, layer)
	assert(StateHistory[player] and StateHistory[player][layer], "Invalid history")
	local history = StateHistory[player][layer]
	if #history > 1 then
		table.remove(history) -- Remove current
		local prevState = history[#history]
		PlayerStates[player][layer] = prevState
		StateChanged:Fire(player, layer, prevState)
		StateChangedRemote:FireClient(player, layer, prevState)
	end
end

return StateManager
