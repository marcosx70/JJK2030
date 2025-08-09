--!strict
export type Bind = { Name: string, Keycode: Enum.KeyCode }
export type Keymap = { [string]: Bind }

local Defaults: Keymap = {
	Dash = { Name = "Dash", Keycode = Enum.KeyCode.Q },
	M1 = { Name = "M1", Keycode = Enum.KeyCode.ButtonR2 },
}

local M = {}
function M.GetDefaults(): Keymap return Defaults end
return M