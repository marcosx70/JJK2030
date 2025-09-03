--!strict
-- src/server/Combat/CombatCore.lua

local _Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Types (from your repo)
local Types = require(ReplicatedStorage.Shared.Types.CombatTypes)
type State = Types.CombatState

local Core = {}

-- Per-player state we track server-side for debugging / gating
local _state: { [Player]: State } = {}
local _connections: { [Player]: RBXScriptConnection } = {}

-- Lookup to convert chat text -> typed union
local StringToState: { [string]: State } = {
	Idle = "Idle",
	M1 = "M1",
	M2 = "M2",
	Dash = "Dash",
	Air = "Air",
	Stunned = "Stunned",
	Downed = "Downed",
}

-- ===== Internals =====

local function attachChatDebug(plr: Player)
	-- Clean any previous connection for safety
	if _connections[plr] then
		_connections[plr]:Disconnect()
	end

	local conn = plr.Chatted:Connect(function(msg: string)
		-- /state <Idle|M1|M2|Dash|Air|Stunned|Downed>
		do
			local name = msg:match("^/state%s+(%w+)$")
			if name then
				local s = StringToState[name]
				if s then
					Core.setState(plr, s)
					print(("[CombatCore] %s -> state %s"):format(plr.Name, s))
				else
					warn(("[CombatCore] unknown state '%s'"):format(name))
				end
				return
			end
		end

		-- /stun <seconds>
		do
			local secsTxt = msg:match("^/stun%s+(%d+)$")
			if secsTxt then
				local n = tonumber(secsTxt)
				if n then
					Core.DebugStunFor(plr, n)
					print(("[CombatCore] %s stunned for %ds (debug)"):format(plr.Name, n))
				else
					warn("[CombatCore] /stun needs a number, e.g. /stun 2")
				end
				return
			end
		end
	end)

	_connections[plr] = conn
end

-- ===== Public API (keep signatures stable) =====

function Core.init()
	-- Initialize any runtime data as needed
	for _, plr in ipairs(_Players:GetPlayers()) do
		Core.attachPlayer(plr)
	end
	_Players.PlayerAdded:Connect(Core.attachPlayer)
	_Players.PlayerRemoving:Connect(Core.cleanupPlayer)
end

function Core.Destroy()
	for plr, conn in pairs(_connections) do
		if conn.Connected then
			conn:Disconnect()
		end
		_connections[plr] = nil
	end
	_state = {}
end

-- Exposed for wrapper
function Core.attachPlayer(plr: Player)
	_state[plr] = "Idle"
	attachChatDebug(plr)
end

function Core.cleanupPlayer(plr: Player)
	local c = _connections[plr]
	if c then
		c:Disconnect()
		_connections[plr] = nil
	end
	_state[plr] = nil :: any
end

function Core.getState(plr: Player): State
	return _state[plr] or "Idle"
end

-- Internal setter used by chat + any server logic
function Core.setState(plr: Player, s: State)
	_state[plr] = s
end

-- Debug commands exposed to wrapper/tests
function Core.DebugSetState(plr: Player, s: string)
	local mapped = StringToState[s]
	if mapped then
		Core.setState(plr, mapped)
	else
		warn(("[CombatCore] DebugSetState: unknown state '%s'"):format(s))
	end
end

function Core.DebugStunFor(plr: Player, secs: number)
	-- TODO: integrate your real state manager’s stun logic here
	Core.setState(plr, "Stunned")
	task.delay(secs, function()
		-- Only revert if still stunned
		if Core.getState(plr) == "Stunned" then
			Core.setState(plr, "Idle")
		end
	end)
end

-- Remote handlers (no-op scaffolds here; wire to your real systems)
function Core.onPerfectDodge(plr: Player, payload: any)
	print(("[PD] from %s"):format(plr.Name))
end

function Core.onDash(plr: Player)
	Core.setState(plr, "Dash")
end

return Core
