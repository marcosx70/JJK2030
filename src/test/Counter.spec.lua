--!strict
return function()
	local C = require(game.ReplicatedStorage.Shared.Example.Counter)
	describe("Counter", function()
		it("inc increments", function()
			local c = C.new()
			c:Inc()
			expect(c.value).to.equal(1)
		end)
	end)
end
