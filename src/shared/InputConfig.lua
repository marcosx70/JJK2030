-- InputConfig.lua

local UserInputService = game:GetService("UserInputService")

local InputConfig = {
	_bindings = {
		Jump = Enum.KeyCode.Space,
		Sprint = Enum.KeyCode.LeftShift,
		Dash = Enum.KeyCode.Q,
	},
}

function InputConfig:GetKey(action)
	return self._bindings[action]
end

function InputConfig:SetKey(action, newKeyCode)
	if typeof(newKeyCode) == "EnumItem" and newKeyCode.EnumType == Enum.KeyCode then
		self._bindings[action] = newKeyCode
	else
		warn("Invalid keycode for action:", action)
	end
end

function InputConfig:GetAllBindings()
	return table.clone(self._bindings)
end

return InputConfig
