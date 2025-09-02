--!strict
local RunService = game:GetService("RunService")
if not RunService:IsStudio() then
	return
end -- don't run tests on live servers

local RS = game:GetService("ReplicatedStorage")
local TestEZ = require(RS:WaitForChild("Packages"):WaitForChild("TestEZ"))
local Tests = RS:WaitForChild("Tests")

local results = TestEZ.TestBootstrap:run({ Tests }, TestEZ.Reporters.TextReporter)
if results.failureCount > 0 then
	warn(("TestEZ: %d failed, %d skipped"):format(results.failureCount, results.skippedCount))
else
	print(("TestEZ: %d passed 🎉"):format(results.successCount))
end
