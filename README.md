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

- [x] Fix player bump mechanic

- [x] Push distance
- [ ] Slide feel
- [ ] Dusty/movement animation

- [x] Enemy stun on block hit
  - [ ] Animation
  - [ ] Crumple/flip upside down

- [x] Add win conditions
  - [x] Resource victory
    - [x] Create coin prop
      - [x] Give physics (velocity.x, gravity)
    - [x] Animate coin
    - [x] Sound effect when acquire coin
    - [ ] Spawn coin on enemy kill
  - [x] Last player standing
  - [ ] Tetris queue to see enemies

- [ ] Skull behavior
  - [ ] Damage
  - [ ] Remove enemy stun
  - [ ] Pop enemies up
  - [ ] When two skulls collide, have them cancel out

- [ ] Select Menu before level starts
