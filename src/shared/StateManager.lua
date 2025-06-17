-- StateManager.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StateChangedRemote = ReplicatedStorage:WaitForChild("StateChangedRemote")
local StateChanged = Instance.new("BindableEvent")

local StateManager = {}
local PlayerStates = {}
local StateHistory = {}

-- Define allowed states per layer
local AllowedStates = {
    Movement = { Idle = true, Walking = true, Sprinting = true, Jumping = true, AirDash = true, AerialCombat = true },
    Action = { None = true, Attacking = true, Blocking = true },
    Combat = { Neutral = true, Engaged = true }
}

local function validateState(layer, state)
    return AllowedStates[layer] and AllowedStates[layer][state]
end

Players.PlayerAdded:Connect(function(player)
    PlayerStates[player] = {
        Movement = "Idle",
        Action = "None",
        Combat = "Neutral"
    }
    StateHistory[player] = {
        Movement = { "Idle" },
        Action = { "None" },
        Combat = { "Neutral" }
    }
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerStates[player] = nil
    StateHistory[player] = nil
end)

function StateManager:Set(player, layer, state)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Invalid player.")
    assert(PlayerStates[player], "Player not tracked.")
    assert(validateState(layer, state), "Invalid state for layer: " .. layer)

    PlayerStates[player][layer] = state
    table.insert(StateHistory[player][layer], state)

    StateChanged:Fire(player, layer, state)
    StateChangedRemote:FireClient(player, layer, state)
end

function StateManager:Revert(player, layer)
    local history = StateHistory[player] and StateHistory[player][layer]
    if history and #history > 1 then
        table.remove(history)
        local previousState = history[#history]
        PlayerStates[player][layer] = previousState
        StateChanged:Fire(player, layer, previousState)
        StateChangedRemote:FireClient(player, layer, previousState)
    end
end

function StateManager:Get(player, layer)
    return PlayerStates[player] and PlayerStates[player][layer]
end

function StateManager:IsInState(player, layer, stateList)
    local current = self:Get(player, layer)
    for _, state in ipairs(stateList) do
        if state == current then return true end
    end
    return false
end

function StateManager:GetAll(player)
    local stateCopy = {}
    for layer, state in pairs(PlayerStates[player] or {}) do
        stateCopy[layer] = state
    end
    return stateCopy
end

function StateManager:GetHistory(player, layer)
    return table.clone(StateHistory[player] and StateHistory[player][layer] or {})
end

function StateManager:GetEvent()
    return StateChanged.Event
end

return StateManager
