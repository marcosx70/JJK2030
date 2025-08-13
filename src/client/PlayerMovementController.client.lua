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
		print("[Client] Q pressed at", t) -- << this is the line
		if t - lastDash > 0.35 then
			lastDash = t
			PerfectDodge:FireServer({ t = t })
		end
	end
end)

-- TEMP: press E to ask server to Dash (for testing)
if input.KeyCode == Enum.KeyCode.E then
	local RS = game:GetService("ReplicatedStorage")
	local Dash = RS.Remotes.Combat:WaitForChild("Dash") :: RemoteEvent
	print("[Client] E pressed (Dash intent)")
	Dash:FireServer({})
end
