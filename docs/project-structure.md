# Project Structure

This file defines the intended organization for the SMBM Godot project.

## Root

Keep root focused on project configuration and onboarding:

- `project.godot`
- `export_presets.cfg`
- `README.md`
- `docs/`
- `scenes/`
- `scripts/`
- `assets/`

## Gameplay scenes

- `scenes/levels/` - level scenes (for example, battle map scene)
- `scenes/actors/` - player and enemy scene files
- `scenes/props/` - static and interactive world props

## Gameplay code

- `scripts/actors/player/` - player control and behavior scripts
- `scripts/actors/enemy/` - enemy AI/behavior scripts
- `scripts/systems/` - manager/spawn/game-state systems
- `scripts/world/` - transfer points, bump triggers, and map helpers

## Assets

- `assets/third_party/` - external packs with original folder structure preserved
- `assets/audio/` - in-use SFX/music for gameplay
- `assets/textures/` - project-owned textures/materials (if added later)

## Notes

- Avoid placing new gameplay files at repo root.
- Keep third-party packs isolated from gameplay scenes/scripts.
- Move files through Godot editor so references remain valid.
