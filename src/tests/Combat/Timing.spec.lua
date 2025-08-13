--!strict
return function()
	local RS = game:GetService("ReplicatedStorage")
	local Timing = require(RS:WaitForChild("Shared"):WaitForChild("Combat"):WaitForChild("Timing"))

	describe("Timing", function()
		it("within handles +/- window", function()
			expect(Timing.within(0.05, 0.12)).to.equal(true)
			expect(Timing.within(-0.11, 0.12)).to.equal(true)
			expect(Timing.within(0.13, 0.12)).to.equal(false)
		end)
		it("coalesce respects min gap", function()
			expect(Timing.coalesce(nil, 10.0, 0.15)).to.equal(true)
			expect(Timing.coalesce(10.05, 10.1, 0.15)).to.equal(false)
		end)
	end)
end
