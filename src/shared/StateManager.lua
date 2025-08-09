--!strict
local RunService = game:GetService("RunService")

export type State = "Idle"|"M1"|"M2"|"Dash"|"Air"|"Stunned"|"Downed"
export type StateManager = { state: State, Set: (self: any, s: State) -> (), Get: (self:any)->State, Destroy: (self:any)->() }

local SM = {}
SM.__index = SM

function SM.new(initial: State): StateManager
	return setmetatable({ state = initial or "Idle" }, SM)
end
function SM:Set(s: State) self.state = s end
function SM:Get(): State return self.state end
function SM:Destroy() end

return SM