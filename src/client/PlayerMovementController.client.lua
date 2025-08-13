--!strict
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

-- Remotes
local Remotes = RS:WaitForChild("Remotes")
local Combat = Remotes:WaitForChild("Combat")
local PerfectDodge = Combat:WaitForChild("PerfectDodge") :: RemoteEvent
local Dash = Combat:WaitForChild("Dash") :: RemoteEvent

-- PDodge spam guard (client-side only; server does the real checks)
local lastPD = 0

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	-- Q = Perfect Dodge intent (timestamped)
	if input.KeyCode == Enum.KeyCode.Q then
		local t = os.clock()
		print("[Client] Q pressed at", t)
		if t - lastPD > 0.35 then
			lastPD = t
			PerfectDodge:FireServer({ t = t })
		end
		return
	end

	-- E = Dash intent (payload is empty for now)
	if input.KeyCode == Enum.KeyCode.E then
		print("[Client] E pressed (Dash intent)")
		Dash:FireServer({})
		return
	end
end)
