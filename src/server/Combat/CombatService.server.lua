--!strict
-- Server wrapper: wires remotes and delegates to Core.
print("[CombatService] wrapper starting")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local Remotes = RS:WaitForChild("Remotes"):WaitForChild("Combat")
local RE_PerfectDodge = Remotes:WaitForChild("PerfectDodge")
local RE_Dash = Remotes:WaitForChild("Dash")

local Core = require(script.Parent:WaitForChild("CombatCore"))

-- boot
local function init()
	print("[CombatService] init")

	-- connect player lifecycle
	for _, plr in ipairs(Players:GetPlayers()) do
		Core.attachPlayer(plr)
	end
	Players.PlayerAdded:Connect(function(plr)
		Core.attachPlayer(plr)
	end)
	Players.PlayerRemoving:Connect(function(plr)
		Core.cleanupPlayer(plr)
	end)

	-- wire remotes
	RE_PerfectDodge.OnServerEvent:Connect(Core.onPerfectDodge)
	RE_Dash.OnServerEvent:Connect(Core.onDash)
end

local function destroy()
	Core.Destroy()
	print("[CombatService] destroyed")
end

-- expose a few debug helpers for the Command Bar (server scope)
local Service = {}
Service.DebugSetState = Core.DebugSetState
Service.DebugStunFor = Core.DebugStunFor
Service.GetState = Core.getState
_G.CS = Service -- optional convenience

init()
