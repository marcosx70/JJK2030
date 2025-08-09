--!strict
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")
local Combat = Remotes:WaitForChild("Combat")
local PerfectDodge = Combat:WaitForChild("PerfectDodge") :: RemoteEvent

local lastDash = 0
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Q then
		local t = os.clock()
		if t - lastDash > 0.35 then
			lastDash = t
			PerfectDodge:FireServer({ t = t })
		end
	end
end)