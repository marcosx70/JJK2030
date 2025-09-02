--!strict
-- Pure core logic for combat wrapper to call into.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local StateGate = require(RS.Shared.Combat.StateGate)

local Core = {}

-- internal state
local _state: { [Player]: string } = {}          -- current state per player
local _stunUntil: { [Player]: number } = {}      -- debug stun expiry (os.clock)
local _chatted: { [Player]: RBXScriptConnection } = {}

-- tuning + logging
local LOG_COMBAT = true
local IFRAME_WINDOW = 0.35
local DASH_DURATION = 0.25

-- state helpers
function Core.getState(plr: Player): string?
	return _state[plr]
end
function Core.setState(plr: Player, s: string)
	_state[plr] = s
end

-- remote handlers
function Core.onPerfectDodge(plr: Player, payload: any)
	if LOG_COMBAT and payload and payload.t ~= nil then
		print(("[PD] recv from %s payload.t = %s"):format(plr.Name, tostring(payload.t)))
	end
	if LOG_COMBAT then
		print(("[PD] accept, iframe %.2fs"):format(IFRAME_WINDOW))
	end
	-- Future: register i-frames on server side for hit validation window.
end

function Core.onDash(plr: Player)
	local now = os.clock()
	local left = math.max(0, (_stunUntil[plr] or 0) - now)
	local state = Core.getState(plr) or "Idle"

	if LOG_COMBAT then
		print(("[Dash] requested; state=%s, dbgStun=%.2fs"):format(state, left))
	end

	if left > 0 then
		if LOG_COMBAT then
			print(("[Dash] reject: debug-stun active (%.2fs left)"):format(left))
		end
		return
	end
	if not StateGate.canDash(state) then
		if LOG_COMBAT then
			print(("[Dash] reject: gated by server state (%s)"):format(state))
		end
		return
	end

	Core.setState(plr, "Dash")
	if LOG_COMBAT then print(("[Dash] enter for %.2fs"):format(DASH_DURATION)) end

	task.delay(DASH_DURATION, function()
		Core.setState(plr, "Idle")
		if LOG_COMBAT then print("[Dash] exit -> Idle") end
	end)
end

-- lifecycle per player
function Core.attachPlayer(plr: Player)
	_state[plr] = _state[plr] or "Idle"

	-- inside Core.attachPlayer(plr)
_chatted[plr] = plr.Chatted:Connect(function(msg)
	local secsStr = msg:match("^stun%s+(%d+%.?%d*)$")
	local secs = secsStr and tonumber(secsStr)
	if secs then
		Core.DebugStunFor(plr, secs) -- secs is number here
		return
	end

	local st = msg:match("^state%s+(%a+)$")
	if st then
		Core.DebugSetState(plr, st)
		return
	end
end)

end

function Core.cleanupPlayer(plr: Player)
	if _chatted[plr] then _chatted[plr]:Disconnect() end
	_chatted[plr] = nil
	_state[plr] = nil
	_stunUntil[plr] = nil
end

function Core.Destroy()
	for plr, con in pairs(_chatted) do
		if con.Connected then con:Disconnect() end
		_chatted[plr] = nil
	end
	table.clear(_state)
	table.clear(_stunUntil)
end

-- debug helpers (callable from Command Bar via _G.CS.*)
function Core.DebugSetState(plr: Player, newState: string)
	Core.setState(plr, newState)
	print(("[Debug] %s -> %s"):format(plr.Name, newState))
end

function Core.DebugStunFor(plr: Player, seconds: number)
	_stunUntil[plr] = os.clock() + seconds
	print(("[Debug] %s stunned for %.2fs"):format(plr.Name, seconds))
	task.delay(seconds, function()
		if (_stunUntil[plr] or 0) <= os.clock() then
			_stunUntil[plr] = nil
			print(("[Debug] %s stun cleared"):format(plr.Name))
		end
	end)
end

return Core
