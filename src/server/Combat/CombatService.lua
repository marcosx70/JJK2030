--!strict
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- Folders/Remotes
local Remotes = RS:WaitForChild("Remotes")
local CombatFolder = Remotes:WaitForChild("Combat")
local PerfectDodge = CombatFolder:WaitForChild("PerfectDodge") :: RemoteEvent

-- Shared modules
local StateManager = require(RS:WaitForChild("Shared"):WaitForChild("Systems"):WaitForChild("StateManager"))
local Timing = require(RS:WaitForChild("Shared"):WaitForChild("Combat"):WaitForChild("Timing"))

type StateManagerT = StateManager.StateManager
type PlayerCombat = { lastPDodge: number? }

local LOG_COMBAT = false

local Service = {}
local _connections: { RBXScriptConnection } = {}
local _states: { [Player]: StateManagerT } = {}
local _pc: { [Player]: PlayerCombat } = {}

-- Tunables
local PD_WINDOW = 0.12       -- +/- seconds, latency window
local PD_COOLDOWN = 0.25     -- seconds between accepted PDs
local IFRAME_DURATION = 0.35 -- seconds

local function getChar(plr: Player): Model?
	local c = plr.Character
	if c and c.Parent then return c end
	return nil
end

local function tagIFrame(char: Instance)
	if not CollectionService:HasTag(char, "IFrame") then
		CollectionService:AddTag(char, "IFrame")
		task.delay(IFRAME_DURATION, function()
			if char.Parent then
				CollectionService:RemoveTag(char, "IFrame")
			end
		end)
	end
end

local function onPerfectDodge(plr: Player, payload: any)
	if typeof(payload) ~= "table" then return end
	local tVal = payload.t
	if typeof(tVal) ~= "number" then return end

	local now = os.clock()
	local delta = now - tVal

	if not Timing.within(delta, PD_WINDOW) then
		if LOG_COMBAT then
			warn(("[PD] reject window: %.3f"):format(delta))
		end
		return
	end

	local pc = _pc[plr]
	if not pc then
		pc = {}
		_pc[plr] = pc
	 end

	if not Timing.coalesce(pc.lastPDodge, now, PD_COOLDOWN) then
		if LOG_COMBAT then
			warn("[PD] reject rate: cooldown")
		end
		return
	end

	local char = getChar(plr)
	if not char then return end

	pc.lastPDodge = now
	tagIFrame(char)

	if LOG_COMBAT then
		print("[PD] accept, iframe applied for", IFRAME_DURATION)
	end
end

function Service.init()
	if LOG_COMBAT then print("[CombatService] init") end

	-- Per-player state holders
	_connections[#_connections+1] = Players.PlayerAdded:Connect(function(plr)
		_states[plr] = StateManager.new("Idle")
		_pc[plr] = {}
	end)
	_connections[#_connections+1] = Players.PlayerRemoving:Connect(function(plr)
		_states[plr] = nil
		_pc[plr] = nil
	end)

	-- Backfill already-present players (Play Solo)
	for _, plr in ipairs(Players:GetPlayers()) do
		if not _states[plr] then
			_states[plr] = StateManager.new("Idle")
			_pc[plr] = {}
		end
	end

	-- Remotes
	_connections[#_connections+1] = PerfectDodge.OnServerEvent:Connect(onPerfectDodge)
end

function Service.Destroy()
	for _, conn in ipairs(_connections) do
		conn:Disconnect()
	end
	table.clear(_connections)
	table.clear(_states)
	table.clear(_pc)
	if LOG_COMBAT then print("[CombatService] destroyed") end
end

return Service
