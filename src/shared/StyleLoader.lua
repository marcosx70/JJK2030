-- StyleLoader.lua (new module)

local StyleLoader = {}

local PlayerStyles = {} -- player -> styleName

-- Example styles → animation override IDs
local StyleAnimations = {
	Default = {
		Run = "rbxassetid://123",
		Jump = "rbxassetid://456",
	},
	Kickboxer = {
		Run = "rbxassetid://789",
		Jump = "rbxassetid://012",
	},
}

function StyleLoader:SetStyle(player, styleName)
	if StyleAnimations[styleName] then
		PlayerStyles[player] = styleName
	else
		warn("Invalid style:", styleName)
	end
end

function StyleLoader:GetStyle(player)
	return PlayerStyles[player] or "Default"
end

function StyleLoader:GetAnimationId(player, animationType)
	local style = StyleLoader:GetStyle(player)
	return StyleAnimations[style] and StyleAnimations[style][animationType]
end

function StyleLoader:InitPlayer(player)
	PlayerStyles[player] = "Default"
end

game.Players.PlayerAdded:Connect(StyleLoader.InitPlayer)

return StyleLoader
