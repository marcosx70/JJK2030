--!strict
local StyleLoader = {}
function StyleLoader.Load(styleName: string)
	-- later: load per-style assets/animations
	return { Name = styleName }
end
return StyleLoader