--!strict
-- Shared helper for combat state gating (keeps tests simple).

local RS = game:GetService("ReplicatedStorage")
local StateManager = require(RS:WaitForChild("Shared"):WaitForChild("Systems"):WaitForChild("StateManager"))
type State = StateManager.State

local Gate = {}

function Gate.canDash(state: State): boolean
	-- Block dash while hard-disabled by server states
	return state ~= "Stunned" and state ~= "Downed"
end

return Gate
