--!strict
local Timing = {}

function Timing.within(delta: number, window: number): boolean
	return math.abs(delta) <= window
end

function Timing.coalesce(lastT: number?, nowT: number, minGap: number): boolean
	if lastT == nil then return true end
	return (nowT - lastT) >= minGap
end

return Timing
