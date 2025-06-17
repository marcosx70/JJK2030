-- StateManager.lua
-- Enhanced state tracking for complex multi-layered systems

local StateManager = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- State layering setup
local layeredStates = {
    Movement = "Idle",
    Action = "None",
    Combat = "None"
}

local historyStack = {
    Movement = {},
    Action = {},
    Combat = {}
}

-- Valid states for each layer
local validStates = {
    Movement = { Idle = true, Running = true, Sprinting = true, Jumping = true, Freefall = true, Dashing = true, Hovering = true },
    Action = { None = true, Charging = true, Dodging = true, Stunned = true },
    Combat = { None = true, Engaged = true, Blocking = true, Attacking = true }
}

-- Events
StateManager.StateChanged = Instance.new("BindableEvent")
StateManager.OnStateChanged = StateManager.StateChanged.Event

-- RemoteEvent for replication (to be parented in ReplicatedStorage)
local remoteStateEvent = ReplicatedStorage:FindFirstChild("StateChangedRemote")
if not remoteStateEvent then
    remoteStateEvent = Instance.new("RemoteEvent")
    remoteStateEvent.Name = "StateChangedRemote"
    remoteStateEvent.Parent = ReplicatedStorage
end

function StateManager:Get(layer)
    return layeredStates[layer]
end

function StateManager:Set(layer, newState, player)
    if validStates[layer] and validStates[layer][newState] then
        local oldState = layeredStates[layer]

        -- Push old state to history stack
        table.insert(historyStack[layer], oldState)

        layeredStates[layer] = newState
        StateManager.StateChanged:Fire(layer, newState, oldState)

        if player then
            remoteStateEvent:FireClient(player, layer, newState)
        end
    else
        warn(`[StateManager] Invalid state '{newState}' for layer '{layer}'`)
    end
end

function StateManager:Is(layer, stateName)
    return layeredStates[layer] == stateName
end

function StateManager:IsOneOf(layer, stateTable)
    for _, state in ipairs(stateTable) do
        if layeredStates[layer] == state then
            return true
        end
    end
    return false
end

function StateManager:Revert(layer)
    local history = historyStack[layer]
    if history and #history > 0 then
        local previousState = table.remove(history)
        self:Set(layer, previousState)
    end
end

return StateManager
