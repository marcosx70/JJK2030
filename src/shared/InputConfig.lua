-- InputConfig.lua
-- This module returns a dictionary of key bindings for basic player movement and mobility

local InputConfig = {
    MoveForward = Enum.KeyCode.W,
    MoveBackward = Enum.KeyCode.S,
    MoveLeft = Enum.KeyCode.A,
    MoveRight = Enum.KeyCode.D,
    
    Jump = Enum.KeyCode.Space,
    Dash = Enum.KeyCode.Q, -- You can change this as needed
    Sprint = Enum.KeyCode.LeftShift,
    
    Hover = Enum.KeyCode.E, -- placeholder for cursed-style upgrades
    ToggleCrouch = Enum.KeyCode.C, -- if crouching gets added
}

return InputConfig
