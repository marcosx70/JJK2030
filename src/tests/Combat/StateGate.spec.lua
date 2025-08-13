--!strict
return function()
	local RS = game:GetService("ReplicatedStorage")
	local Gate = require(RS:WaitForChild("Shared"):WaitForChild("Combat"):WaitForChild("StateGate"))
	describe("StateGate", function()
		it("canDash gates on server states", function()
			expect(Gate.canDash("Idle")).to.equal(true)
			expect(Gate.canDash("Dash")).to.equal(true)
			expect(Gate.canDash("Stunned")).to.equal(false)
			expect(Gate.canDash("Downed")).to.equal(false)
		end)
	end)
end
