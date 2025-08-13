--!strict
-- Shared type defs for combat

export type CombatState = "Idle"|"M1"|"M2"|"Dash"|"Air"|"Stunned"|"Downed"

export type PerfectDodgePayload = {
	t: number, -- client os.clock() when key was pressed
}

export type PlayerCombat = {
	lastPDodge: number?, -- last accepted perfect-dodge server time (os.clock)
}

return {}
