 JJK2030
 
**JJK2030** is a Roblox MMORPG project inspired by the world and mechanics of *Jujutsu Kaisen*. The goal is to create an immersive, high-stakes experience featuring deep combat systems, faction-based progression, player-driven quests, and an evolving world.
 
🔧 Project Structure (Rojo-mapped)
 
<pre>
JJK2030/
├── assets/                             # Models, VFX, animations (source files)
│   ├── animations/
│   ├── vfx/
│   └── models/
├── src/
│   ├── client/                         # StarterPlayer/StarterPlayerScripts  (LocalScripts)  *.client.lua
│   ├── server/                         # ServerScriptService/Server          (Scripts)       *.server.lua
│   ├── shared/                         # ReplicatedStorage/Shared            (ModuleScripts) *.lua
│   ├── remotes/                        # ReplicatedStorage/Remotes           (.model.json, plain keys)
│   │   └── Combat.model.json
│   ├── Packages/                       # ReplicatedStorage/Packages
│   │   └── TestEZ/
│   │       └── init.lua                # returns the TestEZ table
│   ├── tests/                          # ReplicatedStorage/Tests             (specs)
│   ├── char/                           # StarterPlayer/StarterCharacterScripts
│   └── ui/                             # StarterGui/UI
├── default.project.json                # Rojo mappings (filesystem → Studio)
└── README.md
</pre>

 
+ 🧠 Key Features (Vertical Slice)
<pre>
-* **R6-based custom combat system** with air combos, parries, stuns, and VFX
-* **Heavenly restrictions**, CE pool, CE efficiency, Six Eyes, RCT systems
-* **Factions, guilds, associations** with quests, upgrades, and raids
-* **Permadeath mechanics** with second wind, reincarnation effects, and unlockables
-* **Crafting and drop systems** from curses for weapons and cursed tools
-* **Class-based PVP and PVE** designed for risk and reward
+* **R6 combat core**: M1/M2 chains, **Dash** with i-frame window, **Perfect Dodge** counter, **Parry**, **AirLaunch/AirPursuit**, **Grab**, **Finish Ritual** hooks.
+* **Server-authoritative damage** and state (Idle/Dash/Air/Stunned/Downed), client only sends intents.
+* **Quest loop** (association/faction boards) including **Train Station build** Phase 1 (materials + Yen sinks).
+* **Drops = materials** → crafting/cursed-tool pipeline (future).
+* **Permadeath loop**: Downed → ally RCT/item revive → finish rituals → (later) soul-plane microchallenge.
+* **Progression hooks**: Mind stat stub, RCT gate stub, CE Sensory tier-0 (debug).
</pre>
 🤖 Dev Tools
<pre>
-* **VS Code + Git** for version control
-* **Copilot + GPT-4o** to assist writing Luau and documenting logic
-* **Todo Tree & Bookmarks** to manage priorities in-code
-* **Roblox Studio** for building, testing, and uploading assets
+* **VS Code + Git**
+* **Rojo** (mappings in `default.project.json`)
+* **Stylua** + **Selene** (format/lint)
+* **TestEZ** (under `src/Packages/TestEZ`)
+* Copilot + GPT (for boilerplate/refactors; architecture stays in-repo)
+* Roblox Studio for runtime testing and asset import
</pre>
 📌 Project Notes
<pre>
-* The `README.md` will evolve as new systems are designed
-* All custom assets (animations, VFX, models) should be stored in `/assets`
-* Client-side scripts should be modular and performance aware
-* Server-side scripts must validate inputs (anti-exploit)
+* `src/Packages` uses **capital P** (case matters across tools).
+* All custom assets (animations, VFX, models) live under `/assets`.
+* Client code is modular and performance-aware; **server validates everything** (rate-limit, range/LOS, timestamps).
+* Follow the **Roadmap canvas** (“JJK2030 — 90-Day Builder’s Roadmap”) for priorities and acceptance.
</pre>
---
 

![Made in Roblox Studio](https://img.shields.io/badge/Made%20With-Roblox%20Studio-brightgreen?style=flat-square)
![License: TBD](https://img.shields.io/badge/License-TBD-lightgrey?style=flat-square)
![License: TBD](https://img.shields.io/badge/License-TBD-lightgrey?style=flat-square)![License: TBD](https://img.shields.io/badge/License-TBD-lightgrey?style=flat-square)
