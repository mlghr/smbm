# SMBM

Godot 4.6 local multiplayer prototype.

## Current project state

- Main scene: `res://scenes/levels/battle_mode_level.tscn`
- Gameplay scripts are organized under `scripts/`.
- Third-party content is organized under `assets/third_party/`.
- Audio used by gameplay is under `assets/audio/`.

## Recommended structure

Use this target layout over time:

- `scenes/` for `.tscn` gameplay scenes
- `scripts/` for `.gd` gameplay code
- `assets/third_party/` for imported packs
- `assets/audio/` for SFX/music used by gameplay
- `docs/` for project notes and migration checklists

See `docs/project-structure.md` and `docs/migration-checklist.md`.

## Important: moving files safely

Move and rename files in the Godot editor FileSystem dock (not Finder/terminal) so references update automatically.

After each batch of moves:

1. Open key scenes and check for missing scripts/resources.
2. Run the game and test movement/spawn flow.
3. Search scripts for hardcoded `res://` strings and update any stale paths.

Canonical gameplay paths:

- Spawn manager: `scripts/systems/manager_script.gd`
- Player scripts: `scripts/actors/player/player1.gd`, `scripts/actors/player/player2.gd`
- Enemy script: `scripts/actors/enemy/skeleton.gd`
- Enemy scene: `scenes/actors/enemy/skeleton.tscn`
- Block prop scene: `scenes/props/block.tscn`
