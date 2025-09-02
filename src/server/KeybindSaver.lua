-- KeybindSaver.lua
-- Handles saving and loading of player keybinds using DataStoreService

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local KeybindStore = DataStoreService:GetDataStore("PlayerKeybinds")

-- Configuration
local DEFAULT_KEYBINDS = {
	Jump = Enum.KeyCode.Space.Name,
	Sprint = Enum.KeyCode.LeftShift.Name,
	Dash = Enum.KeyCode.Q.Name,
	Forward = Enum.KeyCode.W.Name,
	Backward = Enum.KeyCode.S.Name,
	Left = Enum.KeyCode.A.Name,
	Right = Enum.KeyCode.D.Name,
}

local function loadKeybinds(userId)
	local data
	local success, err = pcall(function()
		data = KeybindStore:GetAsync(tostring(userId))
	end)

	if success and data then
		return data
	else
		return DEFAULT_KEYBINDS
	end
end

local function saveKeybinds(userId, bindings)
	pcall(function()
		KeybindStore:SetAsync(tostring(userId), bindings)
	end)
end

Players.PlayerAdded:Connect(function(player)
	local keybinds = loadKeybinds(player.UserId)

	local remoteFolder = Instance.new("Folder")
	remoteFolder.Name = "Remotes"
	remoteFolder.Parent = player

	local loadRemote = Instance.new("RemoteFunction")
	loadRemote.Name = "RequestKeybinds"
	loadRemote.Parent = remoteFolder

	loadRemote.OnServerInvoke = function()
		return keybinds
	end

	local saveRemote = Instance.new("RemoteEvent")
	saveRemote.Name = "SaveKeybinds"
	saveRemote.Parent = remoteFolder

	saveRemote.OnServerEvent:Connect(function(_, bindings)
		if typeof(bindings) == "table" then
			saveKeybinds(player.UserId, bindings)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	-- Optional: Save here if you want autosave fallback
end)
