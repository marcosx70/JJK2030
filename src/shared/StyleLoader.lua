-- StyleLoader.lua
-- Loads and manages fighting style animation overrides

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StyleLoader = {}

local defaultAnimations = {
	Idle = "rbxassetid://DEFAULT_IDLE_ANIM",
	Run = "rbxassetid://DEFAULT_RUN_ANIM",
	Attack = "rbxassetid://DEFAULT_ATTACK_ANIM"
}

-- Replace with actual style animations
local styles = {
	Karate = {
		Idle = "rbxassetid://KARATE_IDLE",
		Run = "rbxassetid://KARATE_RUN",
		Attack = "rbxassetid://KARATE_ATTACK"
	},
	Boxing = {
		Idle = "rbxassetid://BOXING_IDLE",
		Run = "rbxassetid://BOXING_RUN",
		Attack = "rbxassetid://BOXING_ATTACK"
	}
}

-- Placeholder for player style registry
local playerStyles = {}

-- Called once when player joins
function StyleLoader.SetStyle(player, styleName)
	if styles[styleName] then
		playerStyles[player] = styleName
	else
		warn("Unknown style: " .. tostring(styleName))
	end
end

function StyleLoader.GetStyle(player)
	return playerStyles[player] or "Default"
end

function StyleLoader.GetAnimation(player, action)
	local style = StyleLoader.GetStyle(player)
	local styleSet = styles[style] or defaultAnimations
	return styleSet[action] or defaultAnimations[action]
end

-- Optional cleanup
Players.PlayerRemoving:Connect(function(player)
	playerStyles[player] = nil
end)

return StyleLoader
