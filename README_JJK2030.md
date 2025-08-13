# JJK2030 (R6) — Developer README

JJK2030 is a Roblox MMORPG inspired by *Jujutsu Kaisen*. This repo is organized for a **vertical slice**: core combat, one playable zone, a short quest chain, and basic progression hooks. Code is written in **Luau** and synced to Studio with **Rojo**.

---

## Quick Facts (follow these exactly)

- **Rojo is one-way**: filesystem → Studio. Treat Studio as runtime only.
- **Mappings (source of truth is `default.project.json`)**  
  - `ReplicatedStorage/Shared` → `src/shared`  
  - `ReplicatedStorage/Remotes` → `src/remotes`  
  - `ReplicatedStorage/Packages` → `src/Packages` (capital P)  
  - `ReplicatedStorage/Tests` → `src/tests`  
  - `ServerScriptService/Server` → `src/server`  
  - `StarterPlayer/StarterPlayerScripts` → `src/client`  
  - `StarterPlayer/StarterCharacterScripts` → `src/char`  
  - `StarterGui/UI` → `src/ui`
- **Script type by filename**: `*.server.lua` → Script, `*.client.lua` → LocalScript, `*.lua` → ModuleScript.
- **Remotes JSON flavor**: plain keys only (`ClassName` / `Name` + `Children`). No `$className` / `$properties` in this project.
- **TestEZ** lives at `ReplicatedStorage/Packages/TestEZ`, specs under `ReplicatedStorage/Tests`.

---

## Prerequisites

- Roblox Studio (latest stable).
- Git + VS Code.
- Rojo CLI (install via Aftman or binary).  
- Optional: Stylua (formatter), Selene (linter).

---

## Project Layout

```
src/
  client/                  -- LocalScripts (input, UI glue, local FX)
  server/                  -- Server Scripts (authority, data, spawning)
  shared/                  -- Shared ModuleScripts (types, utilities, systems)
  remotes/                 -- *.model.json (RemoteEvent/RemoteFunction trees)
  Packages/                -- ReplicatedStorage packages (e.g., TestEZ)
  tests/                   -- TestEZ specs (requireable on server)
  char/                    -- StarterCharacterScripts (client)
  ui/                      -- StarterGui/UI (client)
```

Keep shared logic in `ReplicatedStorage/Shared` (or nested systems under `ReplicatedStorage/Shared/...`).

---

## Build & Run (Rojo)

1. Open a terminal at the repo root.  
2. `rojo build -o build/JJK2030.rbxlx` to validate the tree (no errors).  
3. `rojo serve` to live-sync. In Studio, open the Rojo plugin and connect to the shown port.  
4. Do **not** edit code in Studio; make changes in VS Code and let Rojo sync.

If Studio already contains older copies of scripts, remove them to avoid duplicate execution.

---

## Tests (TestEZ)

- TestEZ must be available at `ReplicatedStorage/Packages/TestEZ`.  
- Specs go in `src/tests` and sync to `ReplicatedStorage/Tests`.

**Server TestRunner pattern (excerpt):**

```lua
-- ServerScriptService/Server/TestRunner.server.lua
local RS = game:GetService("ReplicatedStorage")
local TestEZ = require(RS:WaitForChild("Packages"):WaitForChild("TestEZ"))
local Tests = RS:WaitForChild("Tests")
TestEZ.TestBootstrap:run({ Tests })
```

Keep specs tiny and focused. Every new system should land with at least one ~10–15 line spec.

---

## Remotes Schema (project flavor)

Create remote trees with **plain-key** JSON models. Example for Combat:

```json
{
  "ClassName": "Folder",
  "Name": "Combat",
  "Children": [
    { "Name": "PerfectDodge",  "ClassName": "RemoteEvent" },
    { "Name": "Dash",          "ClassName": "RemoteEvent" },
    { "Name": "Parry",         "ClassName": "RemoteEvent" },
    { "Name": "Counter",       "ClassName": "RemoteEvent" },
    { "Name": "HitConfirm",    "ClassName": "RemoteEvent" },
    { "Name": "AirLaunch",     "ClassName": "RemoteEvent" },
    { "Name": "AirPursuit",    "ClassName": "RemoteEvent" },
    { "Name": "Grab",          "ClassName": "RemoteEvent" },
    { "Name": "FinishRitual",  "ClassName": "RemoteEvent" },
    { "Name": "RequestDamage", "ClassName": "RemoteFunction" }
  ]
}
```

Keep the entire Combat folder in a **single** `.model.json` for clarity.

---

## Coding Standards

- Put `--!strict` at the top of new scripts. Prefer typed APIs.
- Module pattern: export `init()` and `Destroy()` when the module owns connections/state.
- Store `RBXScriptConnection`s and disconnect in `Destroy()`.
- Use `CollectionService` tags for lightweight state (e.g., `IFrame`, `Downed`, `Finishable`).
- Prefer `task.defer/task.spawn/task.delay` over deprecated `wait()`/`delay()`.

**Light module pattern (shared):**

```lua
--!strict
local Service = {}
local running = false

function Service.init()
	running = true -- connect signals, set up state
end

function Service.Destroy()
	-- disconnect signals, clear state
	running = false
end

return Service
```

---

## Security & Authority

- Server owns combat, progression, drops. Never trust client damage or timers.
- Rate-limit all client intents (token bucket or simple cooldowns).
- Validate range/line-of-sight/states server-side before applying effects.
- RemoteFunction only for immediate responses; prefer RemoteEvent otherwise.

---

## Telemetry & Logs

- Add debug toggles to silence prints in production (`LOG_COMBAT`, `LOG_QUESTS`, etc.).
- Emit simple counters and histograms into tables; expose a dev-only `/dump` command.

---

## Vertical Slice Scope (what we’re building first)

- **Combat:** M1/M2 basics, Dash with iframes, Perfect‑Dodge counter, HitConfirm path.
- **Zone:** one Tokyo block (“Shibuya Alley”) with spawners and a vendor.
- **Quests:** Train Build — gather → deliver → phase progress (materials only).
- **Progression hooks:** Mind stat stub, RCT gate stub, CE sensory tier 0.
- **Perf/ops:** StreamingEnabled tuned; clean logs; small tests for timing/state.

See the 90‑Day Roadmap canvas for sprint breakdown and acceptance criteria.

---

## Git & Contributing

- Small, descriptive commits. Prefer patch-style diffs in PRs.
- Don’t replace working conventions; propose **additive** changes with reasoning.
- Use `git mv` to fix casing (Windows) so Rojo/Studio detect renames correctly.

---

## Troubleshooting

- **Build errors**: check `default.project.json` mappings and folder casing; ensure `src/Packages`, `src/ui`, `src/char` exist.
- **Missing TestEZ**: verify `ReplicatedStorage/Packages/TestEZ/init.lua` returns the library.
- **Remotes not appearing**: confirm `.model.json` uses plain keys and is under `src/remotes`.
- **Duplicate scripts running**: remove stale copies from Studio; Rojo is source of truth.

---

## Licensing

TBD for now. All third‑party assets and packages must respect their licenses.

---

### Credits

JJK2030 by Marcos and collaborators. This README is written to match the repo’s active conventions.

![Made in Roblox Studio](https://img.shields.io/badge/Made%20With-Roblox%20Studio-brightgreen?style=flat-square)
![License: TBD](https://img.shields.io/badge/License-TBD-lightgrey?style=flat-square)