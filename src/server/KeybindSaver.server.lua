--!strict
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore("Keybinds:v1")

Players.PlayerRemoving:Connect(function(plr)
	local ok, err = pcall(function()
		local keymap = plr:FindFirstChild("_Keymap")
		if keymap then store:SetAsync(plr.UserId, keymap.Value) end
	end)
	if not ok then warn("Keybind save failed", plr, err) end
end)