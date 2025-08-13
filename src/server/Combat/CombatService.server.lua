--!strict
local Service = require(script.Parent:WaitForChild("CombatService"))

print("[CombatService] wrapper starting")
Service.init()

game:BindToClose(function()
	Service.Destroy()
end)
