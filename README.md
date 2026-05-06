# SMBM

Battle mode on every drug

## Dev setup

After cloning the repo, run:

```bash
./devtools/setup.sh
```

This configures Git to use the shared hook in `.githooks/pre-commit`, which runs `./devtools/format.sh` before commits and automatically stages formatted `.gd` files.

If you need to re-install or repair the hook later, run:

```bash
./devtools/install-git-hooks.sh
```

## Canonical gameplay paths

Use folder-based gameplay files as the source of truth:

- Main scene: `scenes/levels/battle_mode_level.tscn`
- Manager system: `scripts/systems/manager_script.gd`
- Enemy scene: `scenes/actors/enemy/skeleton.tscn`
- Bump block scene: `scenes/props/block.tscn`

Avoid creating duplicate gameplay scenes/scripts at repo root.

## Remaining Features for MVP

- [ ] Fix player bump mechanic

- Push distance
- Slide feel
- Dusty/movement animation

- [ ] Enemy stun on block hit

- Animation
- Crumple/flip upside down

- [ ] Add win conditions
  - Resource victory
    - Create coin prop
      - Give physics (velocity.x, gravity)
    - Animate coin
    - Sound effect when acquire coin
    - Spawn coin on enemy kill
  - Last player standing
    - Check player_count state every frame. If player_count == 1, display win screen
  - Tetris queue to see enemies
