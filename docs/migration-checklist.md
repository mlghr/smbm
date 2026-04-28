# Migration Checklist

Use this checklist to move from the current flat layout to the target structure with low risk.

## 1) Baseline

- [ ] Open project in Godot and confirm game runs before changes.
- [ ] Commit or stash local work before large move batches.

## 2) Create folders first

- [ ] `scenes/levels`
- [ ] `scenes/actors/player`
- [ ] `scenes/actors/enemy`
- [ ] `scenes/props`
- [ ] `scripts/actors/player`
- [ ] `scripts/actors/enemy`
- [ ] `scripts/systems`
- [ ] `scripts/world`
- [ ] `assets/third_party`
- [ ] `assets/audio`

## 3) Move in small batches (in Godot editor)

- [ ] Move world helper scripts first (`transfer_point_*`, `bump`).
- [ ] Move manager/system scripts next.
- [ ] Move actor scenes/scripts next (`skeleton`, `player*`).
- [ ] Move level scene(s) after actor dependencies are stable.
- [ ] Move third-party packs last, preserving internal structure.

## 4) Fix hardcoded paths

- [ ] Search for `res://` in `.gd` files after each batch.
- [ ] Update stale `load(...)`/`preload(...)` paths.
- [ ] Verify current known path: `manager_script.gd` -> `res://skeleton.tscn`.

## 5) Validate

- [ ] Open moved scenes and resolve missing dependencies.
- [ ] Run gameplay loop (movement, jump, spawn, enemy behavior).
- [ ] Check exported preset still works after path moves.

## 6) Clean up

- [ ] Remove obsolete duplicate scripts once replacements are live.
- [ ] Update README with final canonical paths.
