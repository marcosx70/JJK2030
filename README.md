# JJK2030

**JJK2030** is a Roblox MMORPG project inspired by the world and mechanics of *Jujutsu Kaisen*. The goal is to create an immersive, high-stakes experience featuring deep combat systems, faction-based progression, player-driven quests, and an evolving world.

## 🔧 Project Structure

```
JJK2030/
├── assets/             # Models, VFX, and animations
│   ├── animations/
│   ├── vfx/
│   └── models/
├── src/                # Game logic
│   ├── client/         # Local scripts (UI, effects, input)
│   ├── server/         # Server scripts (combat, data)
│   └── shared/         # Modules shared by client/server
├── init.lua            # Bootstrapping file for new scripts
├── README.md           # This file
```

## 🧠 Key Features To Be Developed

* **R6-based custom combat system** with air combos, parries, stuns, and VFX
* **Heavenly restrictions**, CE pool, CE efficiency, Six Eyes, RCT systems
* **Factions, guilds, associations** with quests, upgrades, and raids
* **Permadeath mechanics** with second wind, reincarnation effects, and unlockables
* **Crafting and drop systems** from curses for weapons and cursed tools
* **Class-based PVP and PVE** designed for risk and reward

## 🚀 Workflow Guidelines

* Use branches when testing major features
* Document all major systems in the `shared/` folder using module scripts
* Commit small, descriptive changes (e.g., `add dash mechanic`, `refactor input handler`)

## 🤖 Dev Tools

* **VS Code + Git** for version control
* **Copilot + GPT-4o** to assist writing Luau and documenting logic
* **Todo Tree & Bookmarks** to manage priorities in-code
* **Roblox Studio** for building, testing, and uploading assets

## 📌 Project Notes

* The `README.md` will evolve as new systems are designed
* All custom assets (animations, VFX, models) should be stored in `/assets`
* Client-side scripts should be modular and performance aware
* Server-side scripts must validate inputs (anti-exploit)

---

Let this serve as your dev HQ. If you're reading this — welcome to **JJK2030**. Let’s build something amazing.

![Made in Roblox Studio](https://img.shields.io/badge/Made%20With-Roblox%20Studio-brightgreen?style=flat-square)
![License: TBD](https://img.shields.io/badge/License-TBD-lightgrey?style=flat-square)