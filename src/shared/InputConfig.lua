-- InputConfig.lua
-- Centralized configuration for key mappings and future GUI remapping support

local UserInputService = game:GetService("UserInputService")

local InputConfig = {
    JUMP_KEY = Enum.KeyCode.Space,
    SPRINT_KEY = Enum.KeyCode.LeftShift,
    DASH_KEY = Enum.KeyCode.Q,
    MOVE_FORWARD_KEY = Enum.KeyCode.W,
    MOVE_BACKWARD_KEY = Enum.KeyCode.S,
    MOVE_LEFT_KEY = Enum.KeyCode.A,
    MOVE_RIGHT_KEY = Enum.KeyCode.D,
}

-- Placeholder for future GUI remapping
function InputConfig:UpdateKeybind(action, newKey)
    if self[action] then
        self[action] = newKey
    end
end

return InputConfig
