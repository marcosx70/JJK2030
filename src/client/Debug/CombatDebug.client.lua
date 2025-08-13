--!strict
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local function ensureGui(): TextLabel
	local p = Players.LocalPlayer
	local sg = p:FindFirstChildOfClass("PlayerGui") or Instance.new("ScreenGui")
	if not sg.Parent then
		sg.Name = "DebugGui"
		sg.ResetOnSpawn = false
		sg.Parent = p:WaitForChild("PlayerGui")
	end
	local lbl = sg:FindFirstChild("IFrameLabel") :: TextLabel
	if not lbl then
		lbl = Instance.new("TextLabel")
		lbl.Name = "IFrameLabel"
		lbl.Size = UDim2.fromOffset(120, 24)
		lbl.Position = UDim2.fromOffset(12, 12)
		lbl.BackgroundTransparency = 0.4
		lbl.TextScaled = true
		lbl.Visible = false
		lbl.Text = "IFRAME"
		lbl.Parent = sg
	end
	return lbl
end

local function bindChar(char: Model)
	local label = ensureGui()
	local function show()
		label.Visible = true
		task.delay(0.4, function() label.Visible = false end)
	end
	-- Fires when tag is added on this client (replicated from server)
	CollectionService:GetInstanceAddedSignal("IFrame"):Connect(function(inst)
		if inst == char then show() end
	end)
end

local function bindPlayer()
	local lp = Players.LocalPlayer
	if lp.Character then bindChar(lp.Character) end
	lp.CharacterAdded:Connect(bindChar)
end

bindPlayer()
