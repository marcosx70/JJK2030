-- InputConfig.lua
-- Configurable key bindings with runtime rebinding support

local InputConfig = {}

-- Default key bindings
local defaultKeys = {
	Jump = Enum.KeyCode.Space,
	Sprint = Enum.KeyCode.LeftShift,
	Dash = Enum.KeyCode.E,
	Forward = Enum.KeyCode.W,
	Backward = Enum.KeyCode.S,
	Left = Enum.KeyCode.A,
	Right = Enum.KeyCode.D,
}

-- Active key mappings (mutable)
InputConfig.Keys = table.clone(defaultKeys)

-- Rebind a key at runtime
function InputConfig.SetKey(actionName, newKeyCode)
	if not defaultKeys[actionName] then
		warn("[InputConfig] Invalid action name:", actionName)
		return
	end
	if typeof(newKeyCode) ~= "EnumItem" or newKeyCode.EnumType ~= Enum.KeyCode then
		warn("[InputConfig] Invalid key code:", newKeyCode)
		return
	end

	InputConfig.Keys[actionName] = newKeyCode
end

-- Reset key to default
function InputConfig.ResetKey(actionName)
	if defaultKeys[actionName] then
		InputConfig.Keys[actionName] = defaultKeys[actionName]
	end
end

-- Reset all keys to default
function InputConfig.ResetAll()
	InputConfig.Keys = table.clone(defaultKeys)
end

-- Get currently assigned key
function InputConfig.GetKey(actionName)
	return InputConfig.Keys[actionName] or defaultKeys[actionName]
end

-- Expose defaults (read-only)
InputConfig.Defaults = table.clone(defaultKeys)

return InputConfig
